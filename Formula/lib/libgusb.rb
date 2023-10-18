class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://github.com/hughsie/libgusb/archive/refs/tags/0.4.7.tar.gz"
  sha256 "3c0f4a01144810ea1ea0c1a8ff7b84098fced7939d002c54a143145a6fbd94d8"
  license "LGPL-2.1-only"
  head "https://github.com/hughsie/libgusb.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "91e5a05059a3cfd0b8237d880dded5578ab6610299aef75f6d7abef3560d4e0c"
    sha256 arm64_ventura:  "7471bd3c20db3c698863c100fcd48d3963ce0fcdcf1486269d806dcb12fddcbe"
    sha256 arm64_monterey: "a506c131d879872ebe65ea5d67107872b1e9fec94f406126c71610d50e08a743"
    sha256 sonoma:         "770d979575e703627bc3df8332028920b2e106b82e1bf8fc77f945890172c974"
    sha256 ventura:        "48adbf22a3652c348ad352e4d49d552bfa5adf59e63c862f8fd522e706a8a221"
    sha256 monterey:       "18c46026d506478be453e58538ce30c5dfff7ab86ab9c18df842f4c918f7576f"
    sha256 x86_64_linux:   "8cbb539fac0681b8c205af7e81a3b1565bc4dd51c8299613421699f8b6b768d4"
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
