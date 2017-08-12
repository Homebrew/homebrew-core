class Gws < Formula
  desc "Manage workspaces composed of git repositories"
  homepage "https://streakycobra.github.io/gws/"
  url "https://github.com/StreakyCobra/gws/archive/0.1.14.tar.gz"
  sha256 "25d2756b67a316ed02b895a469a824269ccb715fd268b50c9937d8998f1b0836"

  bottle :unneeded

  depends_on "bash"

  def install
    bin.install "src/gws"

    bash_completion.install "completions/bash"
    zsh_completion.install "completions/zsh"
  end

  test do
    system "git", "init", "project"
    system "#{bin}/gws", "init"
    output = shell_output("#{bin}/gws status")
    assert_equal "project:\n                              Clean [Local only repository]\n", output
  end
end
