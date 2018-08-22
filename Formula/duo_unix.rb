class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.10.3.tar.gz"
  sha256 "8259af6e24d618401886f6cbd0c8f72ca6ba8ba9cffe04dd3110e672933388ce"

  bottle do
    sha256 "2a12bca90639ebf2a1e483c7b75c2c6659677761f60a0952693eac754a2d6fb8" => :mojave
    sha256 "30393ba2e84c7eb00111f3eccc3f6b214cea93c58ffb2cbdc39ca88f4c7be285" => :high_sierra
    sha256 "5db71e87da7c8b4db91ade92664bc0b8328757391ccf2c68778b55feae23b589" => :sierra
    sha256 "76d1b26e83386c57cbcec73dfcd52ffb1769e1974f9608222ae88b0d978016b0" => :el_capitan
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
