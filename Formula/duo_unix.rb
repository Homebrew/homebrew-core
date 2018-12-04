class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.11.1.tar.gz"
  sha256 "5ac80927fc1359ccaaf225a638b8b7202e491ef65370c00e5c11580d40c8ca7f"

  bottle do
    sha256 "edde2455f0ce7dec33576965709b42ca7d8caadd4ebf1b0dd10e081915f554bb" => :mojave
    sha256 "395476fd1fb995eaaf47194e608cc38beb72a21be93c2ede372022d530388e04" => :high_sierra
    sha256 "d9dd541f8db47e372d772736eca26cdd9e8c43f66fa73fffe752df5189a9398c" => :sierra
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
