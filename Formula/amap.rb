class Amap < Formula
  desc "Perform application protocol detection"
  homepage "https://www.thc.org/thc-amap/"
  url "https://www.thc.org/releases/amap-5.4.tar.gz"
  mirror "https://downloads.sourceforge.net/project/slackbuildsdirectlinks/amap/amap-5.4.tar.gz"
  sha256 "a75ea58de75034de6b10b0de0065ec88e32f9e9af11c7d69edbffc4da9a5b059"
  revision 3

  bottle do
    cellar :any
    sha256 "2e6101b4931a28f1bebe642cd2591abbb49245b478f0805f972cb828fe10eadf" => :mojave
    sha256 "e20c8c6cfa0221a47164565fd4b4484dd4c653d646a8bdbf7f2330ef99c5079e" => :high_sierra
    sha256 "81ff7d4c48a2bb6e0ba15ef0dbcbf31f98f1a1410d65bd53cd60ffc0e8d8c9d1" => :sierra
    sha256 "c90c8fb7641960727299f576812dd38d88f836f9d3b99a21fdf652d2032acb52" => :el_capitan
    sha256 "0ab42765f948fe016bc38c8d6005e66a86e93b4e93b073615baaf0fa0f0e95dc" => :yosemite
    sha256 "18d4464b634e7aec9fefc45079dd97d0867b956ee71f189dc7f0393e77f7dba7" => :mavericks
  end

  depends_on "openssl@1.1"

  def install
    # Last release was 2011 & there's nowhere supported to report this.
    openssl = Formula["openssl@1.1"]
    inreplace "configure" do |s|
      s.gsub! 'SSL_IPATH=""', "SSL_IPATH=\"#{openssl.opt_include}/openssl\""
      s.gsub! 'SSL_PATH=""', "SSL_PATH=\"#{openssl.opt_lib}\""
      s.gsub! 'CRYPTO_PATH=""', "CRYPTO_PATH=\"#{openssl.opt_lib}\""
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"

    # --prefix doesn't work as we want it to so install manually
    bin.install "amap", "amap6", "amapcrap"
    etc.install "appdefs.resp", "appdefs.rpc", "appdefs.trig"
    man1.install "amap.1"
  end

  test do
    openssl_linked = MachO::Tools.dylibs("#{bin}/amap").any? { |d| d.include? Formula["openssl@1.1"].opt_lib.to_s }
    assert openssl_linked
    # We can do more than this, but unsure how polite it is to port-scan
    # someone's domain every time this goes through CI.
    assert_match version.to_s, shell_output("#{bin}/amap", 255)
  end
end
