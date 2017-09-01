class GruntCompletion < Formula
  desc "Bash and Zsh completion for Grunt"
  homepage "https://gruntjs.com/"
  url "https://github.com/gruntjs/grunt-cli/archive/v1.2.0.tar.gz"
  sha256 "02fca1e10d8158cb6ee7a450d23dd11cd9bb867e994466d973a851315050595a"
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
