class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftp.gnu.org/gnu/moe/moe-1.11.tar.lz"
  mirror "https://ftpmirror.gnu.org/moe/moe-1.11.tar.lz"
  sha256 "0efbcbcf5a4a8d966541c6cb099ba0ab6416780366dbce82d9ff995a85a5e2f9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "55c6298deb23524518371ef927aae3e2a4f9c6e2dc52a9318623e0b8f1c41bc7"
    sha256 arm64_big_sur:  "ecf7d889fc677d4fbd201086dc195d5d072dfdbc78fc0c506104a8a1e5216365"
    sha256 monterey:       "c6defb99e4c9c3743c5f1ff438d543a5ce6390d8fc3f96e5594fc22dcff50a9b"
    sha256 big_sur:        "fd26036b9c0e0c72963f91b99f1a0787109af0a519df1d33d0f04d0d0cc12ebe"
    sha256 catalina:       "38b7920c9d82ba731f98bd1a56932b0d0ebe675d6d9006848a48e392013aad5a"
    sha256 mojave:         "688fc7c768e785581675079dd436c9cf3fef36094ea1aa078a8c3fc221d00fbc"
    sha256 x86_64_linux:   "b54eb559d79b40ec9054ac5cea562fbd562c963c9965a126b99ce082e7c859d0"
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
