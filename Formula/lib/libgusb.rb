class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://github.com/hughsie/libgusb/archive/refs/tags/0.4.6.tar.gz"
  sha256 "0ad7e9f68b3e188149c583f411878db418d6f9600fd1b78e96fea11a8399ad0a"
  license "LGPL-2.1-only"
  head "https://github.com/hughsie/libgusb.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "ccea93257265e9b923743260d3a5e916d2676924d21178537052c6d2008d48f9"
    sha256 arm64_monterey: "755005cd9052c130978063da0ba60918efcfeee67229bf8d5d03f2a5b8d3044b"
    sha256 arm64_big_sur:  "6e295369c6a9460aef7447ca6c79b61041a136110d5fedfe358413e3a13e8911"
    sha256 ventura:        "40ba211d6d3a24dd4d86cb987ee8dfb26a559682229558d1d6c22f362bbbf142"
    sha256 monterey:       "1ab4b8f9c2fcc6c2a2386cacd00b383074e8046dc48a286bbe707d67ded1dbee"
    sha256 big_sur:        "4a818f46ae9a80c190b8233ddd4178edda96e0a9ab8f3b8b4a7fa84580209310"
    sha256 x86_64_linux:   "ab0d9958aa919ebaefd426a7897187b6d3fe9a1e814f814d6b7a50fe1e2c09b9"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
