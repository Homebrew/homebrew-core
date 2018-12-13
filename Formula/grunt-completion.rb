class GruntCompletion < Formula
  desc "Bash and Zsh completion for Grunt"
  homepage "https://gruntjs.com/"
  url "https://github.com/gruntjs/grunt-cli/archive/v1.3.2.tar.gz"
  sha256 "c85c4882a53de135d56fba703e35d7b47a89c628382eb5c7d43e250da197502f"
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
