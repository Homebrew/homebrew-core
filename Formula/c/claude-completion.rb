class ClaudeCompletion < Formula
  desc "Bash completion for the Claude Code CLI"
  homepage "https://github.com/arjuhe/claude-completion"
  url "https://github.com/arjuhe/claude-completion/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "644cbc6407efe1adef9644ff0c095bcc77d8aef192e6394509a013e221d3e390"
  license "MIT"

  def install
    bash_completion.install "claude.bash" => "claude"
  end

  test do
    assert_match "-F _claude",
      shell_output("bash -c 'source #{bash_completion}/claude && complete -p claude'")
  end
end
