class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  license "LGPL-2.1-only"
  revision 2
  head "https://github.com/hughsie/libgusb.git"

  stable do
    url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.5.tar.xz"
    sha256 "5b2a00c6997cc4b0133c5a5748a2e616e9e7504626922105b62aadced78e65df"

    # Patch accepted upstream to allow for building without meson-internal
    # Remove on next release
    patch do
      url "https://github.com/hughsie/libgusb/commit/b2ca7ebb887ff10314a5a000e7d21e33fd4ffc2f.patch?full_index=1"
      sha256 "a068b0f66079897866d2b9280b3679f58c040989f74ee8d8bd70b0f8e977ec37"
    end
  end

  bottle do
    sha256 "7fe394a32e306eb3a5acc9f51b6f07cc46243bb863b15f17eea800d2a1a09231" => :big_sur
    sha256 "934cca2fcf888878cf8da4b40cdbd6548d060f09318242c2818ee3686104ee72" => :arm64_big_sur
    sha256 "4a5345775e87130c47c9c78a9fbe16d28c6dcfc7f74dc76850cae8e1a24ad948" => :catalina
    sha256 "571f51cd56f7ed502e349d63909977cdf44629976ce7b81a765d6dce39be8fa4" => :mojave
    sha256 "570e84e48faa46bb217f581272679c26cb47c13e0bfe25a33916782e7cdebfdf" => :high_sierra
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
