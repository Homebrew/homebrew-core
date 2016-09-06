class Amap < Formula
  desc "Perform application protocol detection"
  homepage "https://www.thc.org/thc-amap/"
  url "https://www.thc.org/releases/amap-5.4.tar.gz"
  sha256 "a75ea58de75034de6b10b0de0065ec88e32f9e9af11c7d69edbffc4da9a5b059"
  revision 2

  bottle do
    cellar :any
    revision 1
    sha256 "5e45a4191eb3b768574f8c823f5a4d927366d50b4fd435abd0508d978797e58b" => :el_capitan
    sha256 "62650b87327fa3555e78842b22a9e306865db0779e14c705624ebbaf163cc0b2" => :yosemite
    sha256 "24b1d262f00a3f8c32910766ed1bc1002fb9a16902d62b31927e1912b47b2149" => :mavericks
  end

  depends_on "openssl"

  def install
    # Last release was 2011 & there's nowhere supported to report this.
    openssl = Formula["openssl"]
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
    output = shell_output("otool -L #{bin}/amap")
    assert_match Formula["openssl"].opt_lib.to_s, output
    # We can do more than this, but unsure how polite it is to port-scan
    # someone's domain every time this goes through CI.
    assert_match version.to_s, shell_output("#{bin}/amap", 255)
  end
end
