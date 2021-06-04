class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.7.tar.xz"
  sha256 "da5f25d6873622689b3351486cbe028efc254403f646dd81225dfe8542d8c67d"
  license "LGPL-2.1-only"
  head "https://github.com/hughsie/libgusb.git"

  bottle do
    sha256 arm64_big_sur: "a03dfea8e1edf9bdf901a7d17cb8cbc9aeb7fe4188376db74d51a0f2d9b0a04c"
    sha256 big_sur:       "2fd0b79da4ed73da54bae2ae8624ea7b669cb5fc0ff56271e59a54d17f849095"
    sha256 catalina:      "87dfd4dbc0d2061835c78347f1ea1e37def0091e66ab1da1409b32c03f4a210e"
    sha256 mojave:        "9eda4fe4eae3ab04d80b218ec9f2f5c631b8eadc31a12b0708af1adb7fb44371"
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
      -lintl
      -lusb-1.0
      -lgusb
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
