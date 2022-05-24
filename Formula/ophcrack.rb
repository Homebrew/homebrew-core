class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "https://ophcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/o/ophcrack/ophcrack_3.8.0.orig.tar.bz2"
  sha256 "048a6df57983a3a5a31ac7c4ec12df16aa49e652a29676d93d4ef959d50aeee0"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c6fe8bc24a9051ab7ef2421ddd67dafb4e7c1b80397d8f184aad4cf85bce096d"
    sha256 cellar: :any,                 arm64_big_sur:  "fdc3b1275b2e59028aa2edc99bda3fb93f6ad139f9e5a34aa3e4382b5dc6208e"
    sha256 cellar: :any,                 monterey:       "945f82a2cb3da5abfc71fdf54d2e10356ee581cd7d895da64e53764722526ff6"
    sha256 cellar: :any,                 big_sur:        "d8a76360167fc2fa268916d26cb250b2f5d398c9cd21f6ae6470b145697b83d6"
    sha256 cellar: :any,                 catalina:       "47361d9c18591930ce871fa3c7ab36eaa43003a8a5339238648787cdd748d962"
    sha256 cellar: :any,                 mojave:         "0bdbfbee37e693edff5fc8f71c52f1fb12d6dd07c1e64aa1a20401df0789853a"
    sha256 cellar: :any,                 high_sierra:    "a1061331c1e9b4a726c818005a3d795ba8c73b29ecd78a3828b5e5eafac18107"
    sha256 cellar: :any,                 sierra:         "6229ee0c1e44192fa0d513b7e72e5c72e7fbd29b5ad7f61cd5c5824d76d49105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2bf28a5dccb7020470c149992f9afc7cf2d407b4a92be3fcf81855bd2951eb0"
  end

  depends_on "openssl@1.1"

  uses_from_macos "expat"

  def install
    args = %W[
      --disable-debug
      --disable-gui
      --with-libssl=#{Formula["openssl@1.1"].opt_prefix}
      --prefix=#{prefix}
    ]
    args << "--with-libexpat=#{Formula["expat"].opt_prefix}" if OS.linux?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ophcrack", "-h"
  end
end
