class Geomview < Formula
  desc "Interactive 3D viewing program"
  homepage "http://www.geomview.org"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/geomview/geomview_1.9.5.orig.tar.gz"
  mirror "https://downloads.sourceforge.net/project/geomview/geomview/1.9.5/geomview-1.9.5.tar.gz"
  sha256 "67edb3005a22ed2bf06f0790303ee3f523011ba069c10db8aef263ac1a1b02c0"
  revision 1

  depends_on :x11
  depends_on "openmotif"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (bin/"hvectext").unlink
  end

  test do
    system "#{bin}/geomview", "--version"
  end
end
