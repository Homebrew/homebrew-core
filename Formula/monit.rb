class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.17.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main//m/monit/monit_5.17.1.orig.tar.gz"
  sha256 "f71a22cfb6bd91ff46496e72e1d1b1021ecd651e7748131ce0f995cc37ff0b42"

  bottle do
    cellar :any
    sha256 "ee0e3cdb4adb127fd2c915168e5478701977294e4135e92dfbe3a6a194afb145" => :el_capitan
    sha256 "c1b3dc5c143ae8899ca903c47c44e06f1e968f0c2cf76229ce002ac2aedf6583" => :yosemite
    sha256 "0077fd5e20697c81abba44ba88b5c16a23100e79a52209accb0409747ffe21c1" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
    pkgshare.install "monitrc"
  end

  test do
    system bin/"monit", "-c", pkgshare/"monitrc", "-t"
  end
end
