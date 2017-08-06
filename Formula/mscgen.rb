class Mscgen < Formula
  desc "Parses Message Sequence Chart descriptions and produces images"
  homepage "http://www.mcternan.me.uk/mscgen/"
  url "http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz"
  sha256 "3c3481ae0599e1c2d30b7ed54ab45249127533ab2f20e768a0ae58d8551ddc23"
  revision 2

  bottle do
    cellar :any
    sha256 "f844f3bf6338134126ba771a540313d8e946c5f4643180fd5a3d85bd4b763c64" => :sierra
    sha256 "3c61423420768aede6fd8d39f42ced4ab57251cda5d76ed82a4fba08347e2663" => :el_capitan
    sha256 "bb3a15650bf9ecf9dfaccf29bb5c492fd638020eed627d594c2550da5f4bd77f" => :yosemite
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
