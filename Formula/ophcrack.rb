class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "http://ophcrack.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.6.0/ophcrack-3.6.0.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/o/ophcrack/ophcrack_3.6.0.orig.tar.bz2"
  sha256 "79219baa03afd7e52bc6d365dd5a445bc73dfac2e88216e7b050ad7749191893"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "7eda5a7515ed37e510495ae4da9415cd71e190ed34f1da7b9684e11b9c436ffc" => :el_capitan
    sha256 "730d18d867355147643570adedf97c2ff2413c3b0ca964771928c78a63660a53" => :yosemite
    sha256 "f253ae3bcd270c32a6b1d9a4f7075a24ad917aadf0fa5fa6bba76d0008e4dc27" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-gui",
                          "--with-libssl=#{Formula["openssl"].opt_prefix}",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "-C", "src", "install"
  end

  test do
    system "#{bin}/ophcrack", "-h"
  end
end
