class Pygtkglext < Formula
  desc "Python bindings to OpenGL GTK+ extension"
  homepage "https://projects.gnome.org/gtkglext/download.html#pygtkglext"
  url "https://download.gnome.org/sources/pygtkglext/1.1/pygtkglext-1.1.0.tar.gz"
  sha256 "9712c04c60bf6ee7d05e0c6a6672040095c2ea803a1546af6dfde562dc0178a3"
  revision 2

  bottle do
    cellar :any
    sha256 "c2a2ead95b65a79eecac385c7ec23dab04f8980cfba44e8d51c4cc2de80fd7f3" => :sierra
    sha256 "d946f8f65dd31f5d8ee9e7032b54ec1f259ec11ab57908fd0c4c28f617bb0d21" => :el_capitan
    sha256 "ffac080474197c23fca753fecba77f53f1d25b0b86856fade067f60dc70941d6" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "pygtk"
  depends_on "gtkglext"
  depends_on "pygobject"

  def install
    inreplace "gtk/gdkgl/gdkglext.override", "#include <GL/gl.h>", "#include <gl.h>"

    ENV["PYGTK_CODEGEN"] = "#{Formula["pygobject"].opt_bin}/pygobject-codegen-2.0"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV.append_path "PYTHONPATH", Formula["pygtk"].opt_lib+"python2.7/site-packages/gtk-2.0"
    system "python", "-c", "import pygtk", "pygtk.require('2.0')", "import gtk.gtkgl"
  end
end
