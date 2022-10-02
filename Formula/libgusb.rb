class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.4.1.tar.xz"
  sha256 "39ee01dab6a75f28de7c317e25d24159f511e1bf8e7465e275a0fbc483a48b63"
  license "LGPL-2.1-only"
  head "https://github.com/hughsie/libgusb.git", branch: "main"

  livecheck do
    url "https://people.freedesktop.org/~hughsient/releases/"
    regex(/href=.*?libgusb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4151d01f42fd1d494d6db4bcd75322c469a5db953316e7510a4351926a198fdc"
    sha256 arm64_big_sur:  "c7f9c5d754db1ee300fc672db0e5a2168525ec7f4d3a1682db1bf5239c5dbd93"
    sha256 monterey:       "5fed45633a4371f0a87eaa8a410d64663c55bd66edbd31e2065834687360330b"
    sha256 big_sur:        "805c97b847b3383f0a279c528ac49e52bfa1166083460f9405c4950f8b93547c"
    sha256 catalina:       "e4290df11f02bcedc15609b859100e76cb900517d65157cd694cadceb0531e3f"
    sha256 x86_64_linux:   "d1de2b019df39238a004752e1c92337ba0de115e8b9d7dd88a34b0ff4d773aa6"
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
