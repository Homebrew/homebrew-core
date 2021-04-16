class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.4.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.4.tar.xz"
  sha256 "ddea079c9362fc446701c9fdeeae9ed8f6523fbc15ee75fbadb1d6ee292e11bf"
  license "BSD-3-Clause"
  head "http://git.epicsol.org/epic5.git"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "7e6dfb759ac3bfd707d5b9cc048c115a17489e5e9813fdd249023fe302e3a218"
    sha256 big_sur:       "b26ced9316978f9414cbd97fb0a120dee2b8c66775761b70433e8bb4093e76cb"
    sha256 catalina:      "763db60447f783b7266cc2e4c7bf0199b01419d2db5755d5649c3b5d576bfe09"
    sha256 mojave:        "a45d59473cbaab0e995edc804e615f2ea3708a3f147dc9397d93816c91fc43b9"
  end

  depends_on "openssl@1.1"

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
