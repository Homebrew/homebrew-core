class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna.com.au/ircii/"
  url "https://ircii.warped.com/ircii-20190117.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/i/ircii/ircii_20190117.orig.tar.bz2"
  sha256 "10316f0a3723e4ce3d67fd5a7df10e6bcf30dd0750fb96d5437cacb16b0e9617"
  revision 1

  bottle do
    sha256 "426446f6f4752f66e58ccad00f395cbf24e3b88d155c87d9c89ca38b23e84c13" => :mojave
    sha256 "71e73a226d88f78d1afbaa0b4231cf9e7e1d3998c4b0e556dd0ec80fed24dc07" => :high_sierra
    sha256 "c54e77fcada6cf345612a063ee199fc2504306275c5bec5344989599d3cd16ef" => :sierra
  end

  depends_on "openssl@1.1"

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
