class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftp.gnu.org/gnu/moe/moe-1.11.tar.lz"
  mirror "https://ftpmirror.gnu.org/moe/moe-1.11.tar.lz"
  sha256 "0efbcbcf5a4a8d966541c6cb099ba0ab6416780366dbce82d9ff995a85a5e2f9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "fca841c40f9b05c85f6e32bf63a8dd8bb6fd01e6a4b01be09b1e90e4c684a54e" => :big_sur
    sha256 "161f630213e5567956ac42596fd10eeba2abb16ca6d03a9fffd46ec5205fab63" => :arm64_big_sur
    sha256 "204f87443d288dd953d310ca2e2fa3de0051f460f1586e357ddfdcc540411412" => :catalina
    sha256 "934ee30ec5f7f95c74183e5faf6ccc7ac36c426747476a5a0fb9628a6169de04" => :mojave
    sha256 "fdfffe18871a25a5f0a8cf86ac8682f2cc6623dea335575d39f1dd529ee2ae46" => :high_sierra
    sha256 "f83a8e961f1a7d295741a6abfe7434580761fa485e32498327ffb0e09322fa1e" => :sierra
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
