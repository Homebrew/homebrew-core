class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.10.5.tar.gz"
  sha256 "b8e7c03be01dd17c77d85b2fc286e037e6f544eeec9753ac5b2bdaa6a3ea25e7"

  bottle do
    sha256 "cc06fc5784613ca3c397c006e653698fcdb3348fa6ba05f020b652092fede1a0" => :mojave
    sha256 "0099735c6608ea8c7c0d8c12881d8e1ebc2c65e603eefb3428497b5ded230f9e" => :high_sierra
    sha256 "72daec9e197e401b3d188ea997b6692b421511aa266575f13ac222b828bc7a3a" => :sierra
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
