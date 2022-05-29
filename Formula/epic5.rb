class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.10.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.10.tar.xz"
  sha256 "f7847e9239c7326bbc81e1d96da5b9ad7b562f6c827c4a112613b075823333ed"
  license "BSD-3-Clause"
  head "http://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8c17ccef09942e7eb4606d7836734c3ead31adcfcc80289d08eecd193f166434"
    sha256 arm64_big_sur:  "eeeba38e2498310418108d507d2432db59bb1ccb641c9b496c5538717821f41a"
    sha256 monterey:       "ebd5f3327274ca3390082008ba9ae547bc96ce2fe62c92641d2e2af1a7645e48"
    sha256 big_sur:        "5e1f73c3a5b385e9616c35e9f1c94b1e306b9c2881ac78d8dda0e53fee7b3a1c"
    sha256 catalina:       "cf07900cc5e7ed7290548334b6fdedd10c817ca281cff4c25094ca4d4831ffd5"
    sha256 x86_64_linux:   "a64c419be76a33082193092bbf35099a6a6d47437e216e34172dc41a3f6c51cf"
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
