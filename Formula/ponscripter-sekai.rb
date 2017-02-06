class PonscripterSekai < Formula
  desc "NScripter-like visual novel engine"
  homepage "https://github.com/sekaiproject/ponscripter-fork"
  url "https://github.com/sekaiproject/ponscripter-fork/archive/v0.0.6.tar.gz"
  sha256 "888a417808fd48f8f55da42c113b04d61396a1237b2b0fed2458e804b8ddf426"
  head "https://github.com/sekaiproject/ponscripter-fork.git"

  bottle do
    cellar :any
    sha256 "f861cfa4717bf19c8217152d5a4faebcfa36620fe5ea2d158d5cf0e60aeb1284" => :yosemite
    sha256 "233d70386e36db3826f999fcda824f7853d3ec62b6fc3d1f22cad922ad3cdb1c" => :mavericks
    sha256 "cfe3febe9dfc2d0e3e72a3b9457338820df18429e680c55f9a803620a878b051" => :mountain_lion
  end

  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer" => ["with-libvorbis", "with-smpeg2"]
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
