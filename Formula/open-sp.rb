class OpenSp < Formula
  desc "SGML parser"
  homepage "http://openjade.sourceforge.net"
  url "https://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz"
  sha256 "57f4898498a368918b0d49c826aa434bb5b703d2c3b169beb348016ab25617ce"

  bottle do
    rebuild 3
    sha256 "23c898d85a23d71ef72ed2964ee981b213ee2165488b330c8191990a2320cbb7" => :sierra
    sha256 "aad5609f7adaf04240855c76cc509e0f4d02ed4b2a2dfe4f10634bc6347da115" => :el_capitan
    sha256 "d7b79be390f3c2b2a823e1156d896200db397dffb6cb6e6712d27539e05ca18b" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-doc-build",
                          "--enable-http",
                          "--enable-default-catalog=#{etc}/sgml/catalog",
                          "--enable-default-search-path=#{HOMEBREW_PREFIX}/share/sgml"
    system "make", "pkgdatadir=#{share}/sgml/opensp", "install"
  end
end
