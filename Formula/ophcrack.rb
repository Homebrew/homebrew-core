class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "https://ophcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.7.0/ophcrack-3.7.0.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/o/ophcrack/ophcrack_3.7.0.orig.tar.bz2"
  sha256 "9d5615dd8e42a395898423f84e29d94ad0b1d4a28fcb14c89a1e2bb1a0374409"

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
    system "make", "install"
  end

  test do
    system bin/"ophcrack", "-h"
  end
end
