class Cowsay < Formula
  desc "Configurable talking characters in ASCII art"
  homepage "https://web.archive.org/web/20120225123719/http://www.nog.net/~tony/warez/cowsay.shtml"
  url "https://github.com/tnalpgge/rank-amateur-cowsay/archive/cowsay-3.04.tar.gz"
  sha256 "d8b871332cfc1f0b6c16832ecca413ca0ac14d58626491a6733829e3d655878b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c041ce7fbf41fd89bf620ae848e3b36fe1e69ab3e2dfca18bc2f2e79cfe8063a" => :el_capitan
    sha256 "ffacfb987481394174267fd987dea52607825e3542d1ea3d0b7aa4ccf7ea5cc5" => :yosemite
    sha256 "12c41b969af30817a4dc7ec25572fe1b707b9d4dcb46d8cc06d22264594219c1" => :mavericks
  end

  def install
    system "/bin/sh", "install.sh", prefix
    mv prefix/"man", share
  end

  test do
    output = shell_output("#{bin}/cowsay moo")
    assert_match "moo", output  # bubble
    assert_match "^__^", output # cow
  end
end
