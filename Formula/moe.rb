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
    sha256 "fd26036b9c0e0c72963f91b99f1a0787109af0a519df1d33d0f04d0d0cc12ebe" => :big_sur
    sha256 "ecf7d889fc677d4fbd201086dc195d5d072dfdbc78fc0c506104a8a1e5216365" => :arm64_big_sur
    sha256 "38b7920c9d82ba731f98bd1a56932b0d0ebe675d6d9006848a48e392013aad5a" => :catalina
    sha256 "688fc7c768e785581675079dd436c9cf3fef36094ea1aa078a8c3fc221d00fbc" => :mojave
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
