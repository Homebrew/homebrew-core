class GruntCompletion < Formula
  desc "Bash and Zsh completion for Grunt"
  homepage "https://gruntjs.com/"
  url "https://github.com/gruntjs/grunt-cli/archive/v1.3.1.tar.gz"
  sha256 "dc881d14faf1ae4659833153ad99f928d60e616bfa181ff3b2fa5de59d3e4344"
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
