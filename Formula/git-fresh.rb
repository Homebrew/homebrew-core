class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.12.0.tar.gz"
  sha256 "199a35e695a839609159b08667c19d361716d882fc5e44a8ec164dc580fb1edc"

  bottle :unneeded

  def install
    system "./install.sh", bin
    man1.install "git-fresh.1"
  end

  test do
    system "#{bin}/git-fresh", "-T"
  end
end
