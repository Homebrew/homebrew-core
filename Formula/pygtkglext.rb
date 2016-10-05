class Pygtkglext < Formula
  desc "Python bindings to OpenGL GTK+ extension"
  homepage "https://projects.gnome.org/gtkglext/download.html#pygtkglext"
  url "https://download.gnome.org/sources/pygtkglext/1.1/pygtkglext-1.1.0.tar.gz"
  sha256 "9712c04c60bf6ee7d05e0c6a6672040095c2ea803a1546af6dfde562dc0178a3"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "557cc993d510558dfd85151ed544c64c92f4e7727d616cdf9f7f9a7b8807215c" => :sierra
    sha256 "a03c4c40feba00df99f0a879198b8c3155cfd25a8a7459c9be5389097be156d3" => :el_capitan
    sha256 "4fde85f03529fbf7480bf31a78904660121e565e7758d03e1d48cf878dfe4f7b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "pygtk"
  depends_on "gtkglext"
  depends_on "pygobject"

  def install
    ENV["PYGTK_CODEGEN"] = "#{Formula["pygobject"].opt_bin}/pygobject-codegen-2.0"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "python", "-c", "import pygtk", "pygtk.require('2.0')", "import gtk.gtkgl"
  end
end
