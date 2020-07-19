class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.11.4.tar.gz"
  sha256 "2fcba3e50fd477699d013c789ffc73a0b10c204d25c455abe7c81a2ecd886579"
  license "GPL-2.0"

  bottle do
    sha256 "67a6ff6605578e287fc862f6fb2ee9360dea7c22f8fbaa97a1bf18dd13db5ec0" => :catalina
    sha256 "753e3f0d60c4c0404a6e347d052bc1ed4bd1e66b43170675549a36d4fe736f25" => :mojave
    sha256 "8e707bc378fa13dfd92fb39e0de055c58f2470973fe80edc41bf500e4863128a" => :high_sierra
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
