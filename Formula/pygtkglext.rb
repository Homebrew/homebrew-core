class Pygtkglext < Formula
  desc "Python bindings to OpenGL GTK+ extension"
  homepage "https://projects.gnome.org/gtkglext/download.html#pygtkglext"
  url "https://download.gnome.org/sources/pygtkglext/1.1/pygtkglext-1.1.0.tar.gz"
  sha256 "9712c04c60bf6ee7d05e0c6a6672040095c2ea803a1546af6dfde562dc0178a3"
  revision 4

  bottle do
    cellar :any
    sha256 "fd74b3701d9fe8f423e9df935d91264b08b3273cd6a2d197726f20c140acca54" => :catalina
    sha256 "c6422a1ab0ad17e577f18c415e04e3ad3c980647da2bf74e23c0b7d98258012d" => :mojave
    sha256 "25c1190335a16ed62b8a7ef09342fbda936e30d4e318c713e97dff1a344847ed" => :high_sierra
    sha256 "62ef8746895c3695f1b22d60b2dcd9c9654b2108ed1f23d257684bd22e5b1b2d" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtkglext"
  depends_on "pygobject"
  depends_on "pygtk"

  def install
    inreplace "gtk/gdkgl/gdkglext.override", "#include <GL/gl.h>", "#include <gl.h>"

    ENV["PYGTK_CODEGEN"] = "#{Formula["pygobject"].opt_bin}/pygobject-codegen-2.0"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV.append_path "PYTHONPATH", Formula["pygtk"].opt_lib/"python2.7/site-packages/gtk-2.0"
    system "python2.7", "-c", "import pygtk", "pygtk.require('2.0')", "import gtk.gtkgl"
  end
end
