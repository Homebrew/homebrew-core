class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.5.tar.xz"
  sha256 "5b2a00c6997cc4b0133c5a5748a2e616e9e7504626922105b62aadced78e65df"
  license "LGPL-2.1"

  bottle do
    sha256 "e9080684116b2b6e4c78c1c1be5e8e210fab77b6f6b3d659cae1a9ad0c630bbb" => :catalina
    sha256 "99c0d0471fd33fbf5bc48eeec6dd971d67555ddf47ebe0659f5af0c8d60beeb1" => :mojave
    sha256 "ae5ef65c9ea969ded1eadfb31f65c32789ad3d1d7c78d80560f14a46cab72561" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
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

  # Patch accepted upstream to allow for building without meson-internal
  # Remove on next release
  patch do
    url "https://github.com/hughsie/libgusb/commit/b2ca7ebb887ff10314a5a000e7d21e33fd4ffc2f.patch?full_index=1"
    sha256 "a068b0f66079897866d2b9280b3679f58c040989f74ee8d8bd70b0f8e977ec37"
  end

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
