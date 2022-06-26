class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.12.1.tar.gz"
  sha256 "bcba8eac949c983955eadcd63199a327add3b8f00aa6e7eb87cd7f4e28b2115b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "93857ce1ea478776edcea98db478b2b94cd808395974c174a0c5fae6ae41cbea"
    sha256 arm64_big_sur:  "a7bb94de99cc25ecedbe5c91df71c85d0f35c774defbbc2b6849e271046faf93"
    sha256 monterey:       "0cfae72f5b2e2699497eabcdd32ced127d564eece8a050aa270f6dd27b6f33ef"
    sha256 big_sur:        "84c7729393e2d61d5c2c9539aac0f95a26d97e96de9ab31dffc301c08e0ccb94"
    sha256 catalina:       "488f75648ba0c3adfcd31260f29461d344450d863d0c0153c7cdb2f1feee20d4"
    sha256 x86_64_linux:   "5ed7ae9172b7c965510d98114f8c223e65e742eb5e51419ff83b3d14b5e74e3c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "linux-pam"
  end

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
