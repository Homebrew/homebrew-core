class GruntCompletion < Formula
  desc "Bash and Zsh completion for Grunt"
  homepage "https://gruntjs.com/"
  url "https://github.com/gruntjs/grunt-cli/archive/v0.1.13.tar.gz"
  sha256 "bb291c97f5ac5dc3f549343436f64ff066a0138565e15c794b1636d37fdc4992"
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
