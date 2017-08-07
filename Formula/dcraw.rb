class Dcraw < Formula
  desc "Digital camera RAW photo decoding software"
  homepage "https://www.cybercom.net/~dcoffin/dcraw/"
  url "https://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-9.27.0.tar.gz"
  mirror "https://distfiles.macports.org/dcraw/dcraw-9.27.0.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/MacPorts/mpdistfiles/dcraw/dcraw-9.27.0.tar.gz"
  sha256 "c1d8cc4f19752a3d3aaab1fceb712ea85b912aa25f1f33f68c69cd42ef987099"
  revision 2

  bottle do
    cellar :any
    sha256 "fd86c81c35d07d7fc919b0835975cf2d09407c8d3802508092c2edf8aa1b76d1" => :sierra
    sha256 "1bdb077f41630167865d8f9fdf08747c33fe429c4d09b8d1703791c1273accbd" => :el_capitan
    sha256 "158f4c5794f21b39c2102b721425d9f69ffe78d0b86e28c73f6b36a4e84d44c8" => :yosemite
  end

  depends_on "jpeg"
  depends_on "jasper"
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
