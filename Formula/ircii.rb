class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna.com.au/ircii/"
  url "https://ircii.warped.com/ircii-20151120.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/ircii/ircii_20151120.orig.tar.bz2"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/i/ircii/ircii_20151120.orig.tar.bz2"
  sha256 "5dfd3fd364a96960e1f57ade4d755474556858653e4ce64265599520378c5f65"

  bottle do
    rebuild 1
    sha256 "9e1fbbdb6b3abac22fb52d6cd029bdab058f9d7a2455535881d32fa77d97c5e8" => :sierra
    sha256 "9a2e2275bdb236a0918637e41865eaa18c8eae2f3df3eebdb311a517adc65ac5" => :el_capitan
    sha256 "b79e9fab42085365159d688993a026942df36b70b64cb67d2e06f663a1d212a0" => :yosemite
  end

  depends_on "openssl"

  def install
    ENV.append "LIBS", "-liconv"
    system "./configure", "--prefix=#{prefix}",
                          "--with-default-server=irc.freenode.net",
                          "--enable-ipv6"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    IO.popen("#{bin}/irc -d", "r+") do |pipe|
      assert_match "Connecting to port 6667 of server irc.freenode.net", pipe.gets
      pipe.puts "/quit"
      pipe.close_write
      pipe.close
    end
  end
end
