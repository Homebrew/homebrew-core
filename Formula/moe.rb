class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftp.gnu.org/gnu/moe/moe-1.13.tar.lz"
  mirror "https://ftpmirror.gnu.org/moe/moe-1.13.tar.lz"
  sha256 "43a557bc512f89d6c718e5f41029cfe3a055682620eb8dbece6302f34a26146b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "57d22728f30b5d1e97ff391dfe1d8caa6d97b609d88eb681eff156108fe94632"
    sha256 arm64_monterey: "6c38cece38f6143e4aeac01818ca54f118197f383b1afc21424699d5a97a9eee"
    sha256 arm64_big_sur:  "8326650484531e703e10ad741c0cfb5923c8983859a111f96f26028982ea7181"
    sha256 ventura:        "c44f9353b9ab2a21e3da5961da9fd45e89e2c75d0cd1aeb535923226102b0f0b"
    sha256 monterey:       "57c61e6567f1d67657d3f12b474cbf55f183f2ea4a51b0a9e3327b972bdfbb8b"
    sha256 big_sur:        "a071d0686b00cb471bd8496c1d595edd26da26f923a59213ffa62418f71e9567"
    sha256 x86_64_linux:   "fb50ad51bb0a88d819ce2e090e9a5b37026f8800718556537a900cbbcc529eca"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/moe", "--version"
  end
end
