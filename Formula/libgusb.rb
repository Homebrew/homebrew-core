class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.8.tar.xz"
  sha256 "6d7092ec4e8e4405e75d4c8799512f2c31cdb0d7a8381ee37d1015a4c4fc8407"
  license "LGPL-2.1-only"
  head "https://github.com/hughsie/libgusb.git"

  bottle do
    sha256 arm64_big_sur: "162c2f8e2aa821917680b9b0dd147ec962c5f5576f41aebeca22a8e62cb89f71"
    sha256 big_sur:       "cf83dacead41ee2afadd41cbbb536199b32031766aba49fdc8bf39da285749f3"
    sha256 catalina:      "a61c7235f3c956d25feb3c26c54bbafd09014dc46612055cdc7739c42a7a4ada"
    sha256 mojave:        "556215c83c9a7b50315e94b654614ad94a874698e9dfd3649f8316797bccbf5e"
    sha256 x86_64_linux:  "a3df985eab4a9f01478ff634069c4b743a1c3d38a517db9994aee8df11ccb29a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libusb"
  depends_on "usb.ids"

  def install
    rewrite_shebang detected_python_shebang, "contrib/generate-version-script.py"

    mkdir "build" do
      system "meson", *std_meson_args, "-Ddocs=false", "-Dusb_ids=#{Formula["usb.ids"].opt_share}/misc/usb.ids", ".."
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
      -lusb-1.0
      -lgusb
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
