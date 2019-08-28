class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.1.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.1.tar.xz"
  sha256 "81e18b5f6aa32c5c4b5d01d4cd94e3124b538e3ba42cf7dbb74a6f1f5081f9df"
  revision 1
  head "http://git.epicsol.org/epic5.git"

  bottle do
    sha256 "4abdb34751cea65e816529bbda596a7dc232040290dd5fec4fdd59a6c786c991" => :mojave
    sha256 "743f168eeb02f773f9ae7467e1d7adae9405b846db0adf8f03e23564e5275bf2" => :high_sierra
    sha256 "db98c71f129c0d8bf7d012cc35e5627a6a623db2909153bbebca71b0c19b507e" => :sierra
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
    system "make", "test"
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
