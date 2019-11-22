class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.11.3.tar.gz"
  sha256 "beabba9fc286fea651941548aa830920f465ca6b754adb6fbc050ad420d3ae75"

  bottle do
    sha256 "a41a6f038fb5134b2afef19dd4994d2828aae0273c49d254c64052d9211939e4" => :catalina
    sha256 "fd5f5e51339021d07de78e85e15c1aac887b96df2dabb66ed04e682e0123a1f6" => :mojave
    sha256 "6d78f280c2a556b36497a48c6b13b2abfc683ee734fe3f084491b20e241521e8" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
