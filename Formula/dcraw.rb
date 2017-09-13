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
    sha256 "7f61c315a5c6820b3d4aeb1d79cb53d7f4f1fa9a99d3a2dc6143dbd6482fd23a" => :sierra
    sha256 "94815d5ba879494311ba80c943549d7a2326fe3e5c6b54411af081d3e417a435" => :el_capitan
    sha256 "d976fa7133006d6aa32393f257c21294be073dc6f570968fa647e3ae229eb0b5" => :yosemite
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
