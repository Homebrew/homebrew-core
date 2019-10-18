class Mscgen < Formula
  desc "Parses Message Sequence Chart descriptions and produces images"
  homepage "http://www.mcternan.me.uk/mscgen/"
  url "http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz"
  sha256 "3c3481ae0599e1c2d30b7ed54ab45249127533ab2f20e768a0ae58d8551ddc23"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "315656cf5f9d72907591b4c8a91e635e6aa9b2116cadefe9fdd76db4cff7ae87" => :catalina
    sha256 "1f194eb67147772b362ae5446b2e369b35ee9ffa935c8e22d37cdb4c1364349b" => :mojave
    sha256 "0f125ab1fbaf04c670f252f05358771f1663b3fc59857bcfd855bbb52e01f88b" => :high_sierra
    sha256 "08345683137541d79b6422afd2e269b1ab8c195722e5e71cffa6298a3986d563" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gd"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-freetype",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
