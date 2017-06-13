class PonscripterSekai < Formula
  desc "NScripter-like visual novel engine"
  homepage "https://github.com/sekaiproject/ponscripter-fork"
  url "https://github.com/sekaiproject/ponscripter-fork/archive/v0.0.6.tar.gz"
  sha256 "888a417808fd48f8f55da42c113b04d61396a1237b2b0fed2458e804b8ddf426"
  revision 1
  head "https://github.com/sekaiproject/ponscripter-fork.git"

  bottle do
    cellar :any
    sha256 "a574166724e93c326cb2ce6a22ffdeada634732023bec07a679be5e32c2939f0" => :sierra
    sha256 "db5f2d1431ebf0ee6fcd7e1bddcc62bab7cc2b0c38d915757762bccc1892213f" => :el_capitan
    sha256 "7d3d15fc8c86881d59e64cec1588040c709ab0358fd29c095a5be4a636d562ca" => :yosemite
  end

  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer" => "with-smpeg2"
  depends_on "libvorbis"
  depends_on "smpeg2"
  depends_on "freetype"

  def install
    # Disable building man pages
    inreplace "configure", /.*install-man.*/, ""

    system "./configure", "--prefix=#{prefix}",
                          "--unsupported-compiler"
    system "make", "install"
  end

  test do
    system "#{bin}/ponscr", "-v"
  end
end
