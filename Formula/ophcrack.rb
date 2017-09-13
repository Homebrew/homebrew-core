class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "https://ophcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.7.0/ophcrack-3.7.0.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/o/ophcrack/ophcrack_3.7.0.orig.tar.bz2"
  sha256 "9d5615dd8e42a395898423f84e29d94ad0b1d4a28fcb14c89a1e2bb1a0374409"

  bottle do
    cellar :any
    sha256 "b26cfad32e29ade99cc9f5cdf7fcef97f495d59d425777bb09ec1580b4a35d50" => :sierra
    sha256 "487e28171f39e5f3c9a50bdecb97f984e677f9fb5fed1ddc6dc63a6a3f4c1d61" => :el_capitan
    sha256 "a1107d15c44410c216a4670f3becf20451143c51b96b0cfe958df2a4a597a2db" => :yosemite
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-gui",
                          "--with-libssl=#{Formula["openssl"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"ophcrack", "-h"
  end
end
