class PonscripterSekai < Formula
  desc "NScripter-like visual novel engine"
  homepage "https://github.com/sekaiproject/ponscripter-fork"
  url "https://github.com/sekaiproject/ponscripter-fork/archive/v0.0.6.tar.gz"
  sha256 "888a417808fd48f8f55da42c113b04d61396a1237b2b0fed2458e804b8ddf426"
  revision 2
  head "https://github.com/sekaiproject/ponscripter-fork.git"

  bottle do
    cellar :any
    sha256 "e6cc3939e19ca41fbdd5d4385964beb6eca6a4efa7e92dd4095a06238f46fbf5" => :sierra
    sha256 "8d29e912f4444fc4c7dc1bde505d0178dab297584e5b146692a23f8a0b16c4d5" => :el_capitan
    sha256 "0621a360b7dfac4f685b8adc31ee23adfcaff330b45100516c26a2a79a884ff1" => :yosemite
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
