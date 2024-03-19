class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://github.com/hughsie/libgusb/archive/refs/tags/0.4.8.tar.gz"
  sha256 "9a1fb0d46e4b1ca7ee777ed8177b344e50a849594cd98b51a38a512bef4b3342"
  license "LGPL-2.1-only"
  head "https://github.com/hughsie/libgusb.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "4280fb61e3df7cd1d003db6037c999c73f11284929a4984535a9538b1f257fa4"
    sha256 arm64_ventura:  "163f59b3ed0fd596467c633908f6445a535d9f96634b19e4e5e24238e1626f56"
    sha256 arm64_monterey: "1069e85229fa8350a8b98db356f016691167b6c667dc9cbdd74dafc07ecc3038"
    sha256 sonoma:         "a06ad66c46e85bf3552274bf15b07806717fc786c3d24a9be4a9d846cd5be9e1"
    sha256 ventura:        "30729a4fbe3276c0b5e5ec40e3528f887eeccdd8ac22c8dc6570f79709befaa0"
    sha256 monterey:       "d768f94968b016d952fd06f2c0d007fd0c024b373162833688e10658d7e8f0d2"
    sha256 x86_64_linux:   "0d939b43d5d3fb30c1e25e4028a217be8883f8f12b90f5929f3d7e8c020a8133"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libusb"
  depends_on "usb.ids"

  def install
    rewrite_shebang detected_python_shebang, "contrib/generate-version-script.py"

    system "meson", "setup", "build",
                    "-Ddocs=false",
                    "-Dusb_ids=#{Formula["usb.ids"].opt_share}/misc/usb.ids",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
    json_glib = Formula["json-glib"]
    libusb = Formula["libusb"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libusb.opt_include}/libusb-1.0
      -I#{include}/gusb-1
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{libusb.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -ljson-glib-1.0
      -lgobject-2.0
      -lusb-1.0
      -lgusb
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
