class Gws < Formula
  desc "Manage workspaces composed of git repositories"
  homepage "https://streakycobra.github.io/gws/"
  url "https://github.com/StreakyCobra/gws/archive/0.1.11.tar.gz"
  sha256 "8a688b20b6f2a9c2228bd498dd68f2058a54429d89c0f6200997dd90c134b832"

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
