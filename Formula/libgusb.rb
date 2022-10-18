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
    sha256 arm64_monterey: "8d4ea7bb7e9a4df51b554cf902c9eef21e1b5df6b8d683441a5503c61c3c7062"
    sha256 arm64_big_sur:  "3f00d4e2a4ec884795ba3006545da31440f3a5251297950d0661d8df8adfcb2a"
    sha256 monterey:       "c0c8ef9e19dae8318c080394db194ad779890495403f1500c19776fdcef3eddc"
    sha256 big_sur:        "740a340439a57c96e0a14f3209a1c12aef8a61da97aaf0e3ea608a1f2991a826"
    sha256 catalina:       "0bec78a26e08e9e4f787336dbd71179dbb4f73431f6c501ee998d175f24c295d"
    sha256 x86_64_linux:   "0f151eda713a227e42a4cb297ad03de275ebba8af7946ed61a67e57d2d537596"
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
