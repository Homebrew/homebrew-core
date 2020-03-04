class Libgusb < Formula
  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.4.tar.xz"
  sha256 "581fd24e12496654b9b2a0732f810b554dfd9212516c18c23586c0cd0b382e04"

  bottle do
    sha256 "76f5259965a34d7103b135620a99a241d201ddbbc8ae487f5baf27f2fb5b9c0f" => :catalina
    sha256 "6e79520023ec8b49404af47096b7daafb31d195feb90026beb4bc445a9a8a1bd" => :mojave
    sha256 "9878b11715c9148335365c0886554b34f576b9c4a0319fd91afcf278725f067b" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libusb"

  # The original usb.ids file can be found at http://www.linux-usb.org/usb.ids
  # It is updated over time and its checksum changes, we maintain a copy
  resource "usb.ids" do
    url "https://github.com/Homebrew/formula-patches/raw/7974b33541d9c284ebb98bdb04075e9ce462d0bd/libgusb/usb.ids"
    sha256 "1cdcceedf955feb8e3df72f41cb70e65691f979c5294127f040371756e617395"
  end

  def install
    (share/"hwdata/").install resource("usb.ids")
    inreplace "contrib/generate-version-script.py", "#!/usr/bin/python3", "#!/usr/bin/env python3"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Ddocs=false", "-Dusb_ids=#{share}/hwdata/usb.ids", ".."
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
