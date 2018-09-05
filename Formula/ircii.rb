class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna.com.au/ircii/"
  url "https://ircii.warped.com/ircii-20170704.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/ircii/ircii_20170704.orig.tar.bz2"
  sha256 "4e5a70fc4577de06fd5855ab7ca0a501fd16e02d5fd34e434a2b5abac80a2eda"

  bottle do
    sha256 "aaf1bd01be68a060cd5e0323a6f645a05f2395708697a9754c518155f1dbd394" => :mojave
    sha256 "d459c638c8c9d2e0f88b4382f592b4cd28d815b0455c799a9f89fba6c6b95496" => :high_sierra
    sha256 "e8168dd5f7bb02880b0f8d199326fb81d7cf068cd2960d10aadd698d645bfa5a" => :sierra
    sha256 "bd98e7588df62ead1c94d09b2fb200475f4c09a0950a572ae527f13f6443107e" => :el_capitan
    sha256 "2bc24641161180093f7ea30ddbe7692afda55f1bbf9d46ed59b7773acf8137de" => :yosemite
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
