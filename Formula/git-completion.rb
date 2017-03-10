class GitCompletion < Formula
  desc "Bash and Zsh completion for Git"
  homepage "https://github.com/git/git"
  url "https://github.com/git/git/archive/v2.12.0.tar.gz"
  sha256 "1f94b3bbe2928b63ce7d743438052ad07f21b20e91ca5b9161e03fd220269016"

  head "https://github.com/git/git.git"

  bottle :unneeded

  conflicts_with "git",
    :because => "both install `git` completions"

  def install
    bash_completion.install "contrib/completion/git-completion.bash" => "git"
    zsh_completion.install "contrib/completion/git-completion.zsh" => "_git"
  end

  test do
    assert_match "-F __git",
      shell_output("source #{bash_completion}/git && complete -p git")
  end
end
