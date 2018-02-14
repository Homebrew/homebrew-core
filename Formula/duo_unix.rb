class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.10.2.tar.gz"
  sha256 "b12de0ab2600ad7021a332eb7fbbb239867f639959e79d74259ec5fe1b5d9234"

  bottle do
    sha256 "8d537b9dcd36f7b6c708fdc0117d9ae8d1f98ffb22962a7b01cb62d4a557da80" => :high_sierra
    sha256 "34ea4ec8b16e5f897caa6e0791d0c9a130941d0e0ed9b5362087a839f8d79a97" => :sierra
    sha256 "cd89bf80fd63c234ef6d18dd82a9d33d9f19f786b267ca4008f7cf004e78b9bc" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
