class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.2.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.2.tar.xz"
  sha256 "5e41cf00f924e79e3503dd456ecd9b1dd93ac447c2573d4fa7da03b8bd19dbad"
  head "http://git.epicsol.org/epic5.git"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "a605174db456c66cd490bd10ef1c0b0f7ae4c9d1a21462757a072429cdebcd13" => :big_sur
    sha256 "c2510a819fc48e5b9020247d44e4acd10cc5acbb04bd8b9b6c74a86130b42edb" => :arm64_big_sur
    sha256 "c9aceac94f6264f34f915b36cd0787a636fea6487ecd1795530800b98861160a" => :catalina
    sha256 "41bc8ef329eec3234db4b238933e4d1048ca27519ad0464683a79a8038c8e646" => :mojave
    sha256 "e7a0f24c252fe24ad8d0425da98026fde6dbc0187bd94b6584e562d36ea92573" => :high_sierra
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
