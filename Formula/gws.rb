class Gws < Formula
  desc "Manage workspaces composed of git repositories"
  homepage "https://streakycobra.github.io/gws/"
  url "https://github.com/StreakyCobra/gws/archive/0.2.0.tar.gz"
  sha256 "f92b7693179c2522c57edd578abdb90b08f6e2075ed27abd4af56c1283deab1a"

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
    assert_equal "project:\n  *                           Clean [Local only repository]\n", output
  end
end
