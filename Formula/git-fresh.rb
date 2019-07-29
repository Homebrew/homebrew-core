class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.12.1.tar.gz"
  sha256 "48be2629113ba77a2a6d8fd478b7186f7237669e9495e768b9d3133704c49dde"

  bottle :unneeded

  def install
    system "./install.sh", bin
    man1.install "git-fresh.1"
  end

  test do
    system "#{bin}/git-fresh", "-T"
  end
end
