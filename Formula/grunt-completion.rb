class GruntCompletion < Formula
  desc "Bash and Zsh completion for Grunt"
  homepage "https://gruntjs.com/"
  url "https://github.com/gruntjs/grunt-cli/archive/v1.3.0.tar.gz"
  sha256 "fb54cf00de54d90a40700714b8d642172abb6bd4f21d562f0c6d7350d5949e61"
  head "https://github.com/gruntjs/grunt-cli.git"

  bottle :unneeded

  def install
    bash_completion.install "completion/bash" => "grunt"
    zsh_completion.install "completion/zsh" => "_grunt"
  end

  test do
    assert_match "-F _grunt_completions",
      shell_output("source #{bash_completion}/grunt && complete -p grunt")
  end
end
