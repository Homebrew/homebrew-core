class PonscripterSekai < Formula
  desc "NScripter-like visual novel engine"
  homepage "https://github.com/sekaiproject/ponscripter-fork"
  url "https://github.com/sekaiproject/ponscripter-fork/archive/v0.0.6.tar.gz"
  sha256 "888a417808fd48f8f55da42c113b04d61396a1237b2b0fed2458e804b8ddf426"
  revision 1
  head "https://github.com/sekaiproject/ponscripter-fork.git"

  bottle do
    cellar :any
    sha256 "26fd678d5457459aeca1ad7c20d4dabd6d80052c8ce0a70c60bf4c4d092b85eb" => :sierra
    sha256 "68c5890468fcac629aeb412240627bb5a7981b533372be483b56587779ce80c8" => :el_capitan
    sha256 "3ead145dede348a02cc915c1ff622705dff717a79f37439a0f4c7389c04e5ac8" => :yosemite
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
