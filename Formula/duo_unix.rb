class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-2.0.0.tar.gz"
  sha256 "d1c761ce63eee0c35a57fc6b966096cac1fd52c9387c6112c6e56ec51ee1990b"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "a9f128f7fe11324bc828e24c2dee60bffd69ab9b50d2d678c55ef02fc35ccd87"
    sha256 arm64_monterey: "08bce85c82251dead2bf052f6ce1fef322d1b6f7c2faf485625a2e5dcedc536b"
    sha256 arm64_big_sur:  "2ab1b40f96e8b1e6f23b05e56f0f403b619c3e9888bf874f80e9fc5fc76a9574"
    sha256 monterey:       "e55cb39233e2291cfc2470d3efb3e3e801d4ca60458c3cce4b29928689db7d54"
    sha256 big_sur:        "85ccdfae0db6736bb4637065a1b94dbce891bac3fc1c0af87cd6a8f853ace742"
    sha256 catalina:       "b1f3ab30a252a64d64301fb4d09b78d57702037b763015732ddeb5e62818c4e5"
    sha256 x86_64_linux:   "54c6ffd4d7d342fe985ae8d39f0131444125f45b18c210e56501dd266f992160"
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
