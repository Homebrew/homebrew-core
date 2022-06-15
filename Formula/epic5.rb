class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.11.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.11.tar.xz"
  sha256 "388f7dd923cf8495f81eb197be6820ba8f345f886d1496850959e8d1f29dc3fa"
  license "BSD-3-Clause"
  head "http://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d22abb49e215165ca1a4f9d3483cec83490292b35e93bf28deaf27cbbf68a1f4"
    sha256 arm64_big_sur:  "b329cba06bf3fedccf2aba4603cb7824cbc1d7cf46e49d2a1a22b2cb8e3c57e1"
    sha256 monterey:       "b59c5dd071bf379df554976ed6d7098953c8f520ee7d31781832a52c9c64d4be"
    sha256 big_sur:        "1e11a5b35697b818afc96bdac745e2e2dcf9427ef4e0b1725c3739d4383b5a46"
    sha256 catalina:       "3072137c8b5b1be2071a6ff21f2957cfec935bd185afd2ee138a03c105aac4e7"
    sha256 x86_64_linux:   "cafcea3d7cd09396a294b415e8927b3dc22442cd04649aae824683db1bf0554a"
  end

  depends_on "openssl@1.1"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
