class Pygtkglext < Formula
  desc "Python bindings to OpenGL GTK+ extension"
  homepage "https://projects.gnome.org/gtkglext/download.html#pygtkglext"
  url "https://download.gnome.org/sources/pygtkglext/1.1/pygtkglext-1.1.0.tar.gz"
  sha256 "9712c04c60bf6ee7d05e0c6a6672040095c2ea803a1546af6dfde562dc0178a3"
  revision 3

  bottle do
    cellar :any
    sha256 "43b3818d1812269ac6897d843ac35da5a1358744681f93997fc47dd9b40b39b1" => :mojave
    sha256 "6b23a741936e9c1642777211397fc59e5e41fa4f34d45c85aad8dd1810ac2aca" => :high_sierra
    sha256 "9ca36d2fbeedb1f45c3151c93df3a827d66f7596f2a91b11de72e7edc830cf98" => :sierra
    sha256 "2d16fc485d3e86ae0d879261984fd2a0cd7725964939a10487ae51e1876716d3" => :el_capitan
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
