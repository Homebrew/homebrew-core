class OpenSp < Formula
  desc "SGML parser"
  homepage "http://openjade.sourceforge.net"
  url "https://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz"
  sha256 "57f4898498a368918b0d49c826aa434bb5b703d2c3b169beb348016ab25617ce"

  bottle do
    rebuild 2
    sha256 "65c3648bd7ce48bef4803ea608fc27cd3fe78fccbf3a329a2670f84af4124d4d" => :sierra
    sha256 "fb795bc471277017e309d2f869dc2a06d61d643545a75d03f40534c600ab92ab" => :el_capitan
    sha256 "bc70e3434884459a653d26f2f58772def6a819132c7ef247326745faede0196f" => :yosemite
    sha256 "b1a305eed7f53817549187981a3916ebecdf76aba4b9003ed20d703f7dfc6b99" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-doc-build",
                          "--enable-http",
                          "--enable-default-catalog=#{HOMEBREW_PREFIX}/share/sgml/catalog",
                          "--enable-default-search-path=#{HOMEBREW_PREFIX}/share/sgml"
    system "make", "pkgdatadir=#{share}/sgml/opensp", "install"
  end
end
