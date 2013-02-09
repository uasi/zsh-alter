_alter-rewrite-buffer() {
	local cmd args altered_buffer
	cmd="${${(z@)BUFFER}[1]}"
	args="${${(z@)BUFFER}[2,-1]}"
	if [[ "$cmd" == "noalter" ]]; then
		if [[ "${BUFFER[1]}" == " " ]]; then
			BUFFER=" $args"
		else
			BUFFER="$args"
		fi
		return
	fi
	altered_buffer=`${(z)1} "$cmd" "$args" "$BUFFER"`
	if [[ -n "$altered_buffer" ]]; then
		BUFFER="$altered_buffer"
	fi
}
_alter-accept-line() {
	local rc="${ALTERRC-.alterrc}"
	if [[ -x "$rc" ]]; then
		_alter-rewrite-buffer "$rc"
	elif [[ -e "$rc" ]]; then
		_alter-rewrite-buffer "zsh $rc"
	elif [[ -x "$HOME/$rc" ]]; then
		_alter-rewrite-buffer "$HOME/$rc"
	elif [[ -e "$HOME/$rc" ]]; then
		_alter-rewrite-buffer "zsh $HOME/$rc"
	fi
	zle accept-line
}

zle -N _alter-accept-line-widget _alter-accept-line

alter-enable() {
	bindkey '^J' _alter-accept-line-widget
	bindkey '^M' _alter-accept-line-widget
}

alter-disable() {
	bindkey '^J' accept-line
	bindkey '^M' accept-line
}
