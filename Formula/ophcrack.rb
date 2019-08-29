class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "https://ophcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/o/ophcrack/ophcrack_3.8.0.orig.tar.bz2"
  sha256 "048a6df57983a3a5a31ac7c4ec12df16aa49e652a29676d93d4ef959d50aeee0"
  revision 1

  bottle do
    cellar :any
    sha256 "c5477f7cf1a1092ff2c3a973bbaf48560a23df09e67d25963eee21ab2e4f91c5" => :mojave
    sha256 "5fa70c9c1293d366594b8c3f16f77a31cfc562dbc7b882c919458efa34d387f8" => :high_sierra
    sha256 "60021285ce03e3a40f946906879ad053ec68fec04e8ab299b3362e8b487e274f" => :sierra
    sha256 "cdc8ef23e5f78936b3c3840a18a6ea2fcee63cb3ba16ff2037d995221e0ae7cf" => :el_capitan
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-gui",
                          "--with-libssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"ophcrack", "-h"
  end
end
