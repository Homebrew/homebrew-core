class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "https://ophcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/o/ophcrack/ophcrack_3.8.0.orig.tar.bz2"
  sha256 "048a6df57983a3a5a31ac7c4ec12df16aa49e652a29676d93d4ef959d50aeee0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e41f04e49fca501a9e1d89633b0b886e453d96fd13694984f249ac635210cc99" => :high_sierra
    sha256 "1ed576b4732417683e4e76269219820189f9156bf029b7ef72b2e39a0ca9ae0a" => :sierra
    sha256 "2191c116efb36a1841c24fbab18acae33a1146027543f2008a68bd46704ae77c" => :el_capitan
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
