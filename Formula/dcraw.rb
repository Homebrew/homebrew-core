class Dcraw < Formula
  desc "Digital camera RAW photo decoding software"
  homepage "https://www.cybercom.net/~dcoffin/dcraw/"
  url "https://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-9.27.0.tar.gz"
  mirror "https://distfiles.macports.org/dcraw/dcraw-9.27.0.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/MacPorts/mpdistfiles/dcraw/dcraw-9.27.0.tar.gz"
  sha256 "c1d8cc4f19752a3d3aaab1fceb712ea85b912aa25f1f33f68c69cd42ef987099"

  bottle do
    cellar :any
    sha256 "44369bd668c640cf403109918b658bfeaf508a9fd6f01b989737f1543932fb87" => :sierra
    sha256 "0bde35e1b1208c2748c70d549f53ff4c83178e5fb3423fd61b2feaba8387a221" => :el_capitan
    sha256 "7773cd46b2f7b316cda1033999d8d8a9c16e2b5f0c552b438f0dfbf59070a229" => :yosemite
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
