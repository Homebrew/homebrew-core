class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.4.tar.xz"
  sha256 "581fd24e12496654b9b2a0732f810b554dfd9212516c18c23586c0cd0b382e04"
  license "LGPL-2.1"

  bottle do
    sha256 "9e916fa412c48ec87a1e637011a8427e7486282196c7357b755613f714a552cf" => :catalina
    sha256 "73c5ad041e47e22306ab183df0bbb40e7cb257e5e3cf657f83627142f6b57fbc" => :mojave
    sha256 "d854847ba9e74654ca556a6a86dfd9569e99fddfeaaf0e94ad844ba26b282994" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libusb"

  # The original usb.ids file can be found at http://www.linux-usb.org/usb.ids
  # It is updated over time and its checksum changes, we maintain a copy
  resource "usb.ids" do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4235be3ce12f415f75869349af9a4198543f167a/simple-scan/usb.ids"
    sha256 "ceceb3759e48eaf47451d7bca81ef4174fced1d4300f9ed33e2b53ee23160c6b"
  end

  # remove in next release
  # patch submitted, https://github.com/hughsie/libgusb/pull/38
  patch :DATA

  def install
    rewrite_shebang detected_python_shebang, "contrib/generate-version-script.py"
    (share/"hwdata/").install resource("usb.ids")

    mkdir "build" do
      system "meson", *std_meson_args, "-Ddocs=false", "-Dusb_ids=#{share}/hwdata/usb.ids", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gusbcmd", "-h"
    (testpath/"test.c").write <<~EOS
      #include <gusb.h>

      int main(int argc, char *argv[]) {
        GUsbContext *context = g_usb_context_new(NULL);
        g_assert_nonnull(context);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libusb = Formula["libusb"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{libusb.opt_include}/libusb-1.0
      -I#{include}/gusb-1
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libusb.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lusb-1.0
      -lgusb
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gusb/meson.build b/gusb/meson.build
index fa2b924..f8d4b70 100644
--- a/gusb/meson.build
+++ b/gusb/meson.build
@@ -41,7 +41,7 @@ install_headers([

 mapfile = 'libgusb.ver'
 vflag = []
-if host_machine.system() in ['linux', 'windows']
+if host_machine.system() == 'linux' or host_machine.system() == 'windows'
   vflag += '-Wl,--version-script,@0@/@1@'.format(meson.current_source_dir(), mapfile)
 endif
 gusb = library(
