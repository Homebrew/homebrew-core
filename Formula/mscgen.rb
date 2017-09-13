class Mscgen < Formula
  desc "Parses Message Sequence Chart descriptions and produces images"
  homepage "http://www.mcternan.me.uk/mscgen/"
  url "http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz"
  sha256 "3c3481ae0599e1c2d30b7ed54ab45249127533ab2f20e768a0ae58d8551ddc23"
  revision 2

  bottle do
    cellar :any
    sha256 "e58e70827fcb36172f35a829427e1d6f6bdd571a54fd68880ea3322314827c83" => :sierra
    sha256 "114a6b0dd6ee338029b012910fc1074ae2bb56fc0a2ff229e24d1bc1e56d126c" => :el_capitan
    sha256 "af3dff86415fae2f80ff8f6c49a32b440e65a785db7573c74ef77487192e0811" => :yosemite
  end

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "freetype"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-freetype",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
