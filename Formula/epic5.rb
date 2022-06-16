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
    sha256 arm64_monterey: "af63de3eae852771d1db63823a38e53634cd0a24e1a35e79830063d14c7516eb"
    sha256 arm64_big_sur:  "6373a1df40b7aab7f2c36ee61ebdcabf4ae4e2c15ca5b85d7486b86a09932ea6"
    sha256 monterey:       "6988e740157334be53f06368b6841ee992e1705f2c4b59afea0b9a25008c16c9"
    sha256 big_sur:        "5b32db573d81c702282ac3f94921b8a0bdc6c5d28d862467a9ffe3c06e867782"
    sha256 catalina:       "b00f4b2bf27531d582336ff476124ad11011b49424ff1ff0583fc5cbbdb6cbb6"
    sha256 x86_64_linux:   "c29700dc4d2fbbf17fe9d6edf15414334a6ca73b1294cdc46cb65b35e58303e5"
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
