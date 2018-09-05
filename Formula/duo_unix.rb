class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.10.4.tar.gz"
  sha256 "482e725f12fe92b59616adcac9ac3db2397806dae394b233d7ea3d919bffc516"

  bottle do
    sha256 "ce48b3da1184f313289b8006b8272ecfc582f378b9a5eff1c8a2b11b4073aef6" => :mojave
    sha256 "a2565350e54b87360cf55288030a00910c8e7b9f68478c8f13fcce5fdf5c93d6" => :high_sierra
    sha256 "e9aba3a8e3ce860fec86c16afab97810a2cc26062701babb4f0c2c85b58c0e23" => :sierra
    sha256 "d8088e93ca2a1ed00a71d94e58a86778ed26f99f20d2e582695489b1a6bb86d0" => :el_capitan
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
