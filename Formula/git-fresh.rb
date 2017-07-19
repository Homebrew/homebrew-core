class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.10.0.tar.gz"
  sha256 "8e10f0066732c5e0af19313ca6c271f1fa6145280921dcc2945650f2b83c6f07"

  bottle :unneeded

  def install
    system "./install.sh", bin
  end

  test do
    system "#{bin}/git-fresh", "-T"
  end
end
