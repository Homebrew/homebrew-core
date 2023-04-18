class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-2.0.1.tar.gz"
  sha256 "7ad340531d2305002e3a1994709f08f8434ef0eed711229c419b8b879ed5e7b1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "af0a04b8864501ff6f852cb7f8f462383cd7527525164b9512044e6139ab34b3"
    sha256 arm64_monterey: "b905e7433cfc7d870ffffd4579d960cf05d4671c00cffedbf2661fb9851d717c"
    sha256 arm64_big_sur:  "f6e00dc4e20035f76b5f7b80622ca89d1a7e24b371ce6bab146d35af8b29bcd0"
    sha256 ventura:        "d4add2e21d424b0a3272b7b41323fcbce7f7ef024d9379733bbbf396a2797fe3"
    sha256 monterey:       "1e2f7306463c95d57aacbf92ce1b7395e6f34119ef76d18656dcb9bc76f113c7"
    sha256 big_sur:        "e253446512ea477b4b75f1a89b1db74911853710f99a07787fd62aaf9e5bb73a"
    sha256 x86_64_linux:   "2876aba8b4daf740e443174f197b43ea2dc867c29057089e0f255ce9c97f0868"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

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
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
