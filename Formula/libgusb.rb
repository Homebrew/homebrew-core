class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.4.2.tar.xz"
  sha256 "02d3a992a0cd16c46a346439334417617cd7cd5b2ccc5fe0fe998e9ffb8d5d8a"
  license "LGPL-2.1-only"
  head "https://github.com/hughsie/libgusb.git", branch: "main"

  livecheck do
    url "https://people.freedesktop.org/~hughsient/releases/"
    regex(/href=.*?libgusb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "26b94eb0f0b0e11f546e77604e38b030f699c0f7c496a07080b5439bd102b9a3"
    sha256 arm64_monterey: "5fe3e1113a8f5da64bf91ffbfbba3dcee4220d728100e9c1c8b9c81d9dd08f23"
    sha256 arm64_big_sur:  "3e0a1e44752ffc529b3dc8a6e547370a12c9f2ee94c65340a9688bf80becffe6"
    sha256 ventura:        "910b03c210daf5bae4cd5aac48b65da21bca86f756b70642f3a3ccb4f701dae6"
    sha256 monterey:       "acdafe61076899853b4752a37d3b3546acd5076c418a495ecc0465885e1700fd"
    sha256 big_sur:        "47833b5e1fbb0af7fb51d815006111be192016b4e7cc6a7a01a0fa616cafafa8"
    sha256 catalina:       "1670b0610c28df9ab0eba5568ff8d861a537b9a975d05748be2bbfa0858330f2"
    sha256 x86_64_linux:   "7c57f4cb67a2d2156aa4d5db7144a3731d4e7a1aef4ec37c963e1e09cc26e376"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
