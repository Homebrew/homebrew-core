class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "http://ophcrack.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.6.1/ophcrack-3.6.1.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/o/ophcrack/ophcrack_3.6.1.orig.tar.bz2"
  sha256 "82dd1699eb7340ce8c7913758db2ab434659f8ad0a27abb186467627a0b8b798"

  bottle do
    cellar :any
    sha256 "c37a7312d5fce3d9ef1e860738ca2809628c0c5725aef12a33a30e96b1d9347a" => :sierra
    sha256 "bc44d74d071f2f564b2962bf4db45dc4976999d21c06e11816c2d00d8d309be4" => :el_capitan
    sha256 "509aa40b85cbaff01682574532a9e5670e0ff41f96c0a703a4bc001d6dfea13d" => :yosemite
    sha256 "4de8f2e6d7ec595b97c4a7292b9828f2c165cd74f4c7ad79fe1cb52b63e17989" => :mavericks
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
    system bin/"ophcrack", "-h"
  end
end
