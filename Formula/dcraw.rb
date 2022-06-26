class Dcraw < Formula
  desc "Digital camera RAW photo decoding software"
  homepage "https://www.dechifro.org/dcraw/"
  url "https://www.dechifro.org/dcraw/archive/dcraw-9.28.0.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/dcraw/dcraw-9.28.0.tar.gz"
  sha256 "2890c3da2642cd44c5f3bfed2c9b2c1db83da5cec09cc17e0fa72e17541fb4b9"
  revision 1

  livecheck do
    url "https://distfiles.macports.org/dcraw/"
    regex(/href=.*?dcraw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "81ca4e8b50071303c1bed20a3901dc5041ac72468d470344ed8618307746a662"
    sha256 cellar: :any,                 arm64_big_sur:  "b80d00af67db54c3b346050ee774286b89487e278a91973e2ee1d0ed30a1bb68"
    sha256 cellar: :any,                 monterey:       "d808e057798d60c3daf76cdb9adffce5e762f75b7eeb9f95156b702f46d622ba"
    sha256 cellar: :any,                 big_sur:        "46bb8e39ef71d4fddab93eeafacfacfc942226257452b9491728104c37673380"
    sha256 cellar: :any,                 catalina:       "dd48d13f966ac2d9230a14ca53048438bf9a1976ac63a1b23554b7ed042fd6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8daabf2c986c54cfb169810a2796f2281703366280605cfb3406d9708b290007"
  end

  depends_on "jasper"
  depends_on "jpeg"
  depends_on "little-cms2"

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system ENV.cc, "-o", "dcraw", ENV.cflags, "dcraw.c", "-lm", "-ljpeg", "-llcms2", "-ljasper"
    bin.install "dcraw"
    man1.install "dcraw.1"
  end

  test do
    assert_match "\"dcraw\" v9", shell_output("#{bin}/dcraw", 1)
  end
end
