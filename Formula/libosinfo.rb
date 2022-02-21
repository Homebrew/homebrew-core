class Libosinfo < Formula
  desc "Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.10.0.tar.xz"
  sha256 "a252e00fc580deb21da0da8c0aa03b8c31e8440b8448c8b98143fab477d32305"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?libosinfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "ab606aa8dc9813fec260ebcf955248bf5e307e5e5cc7023f0455f54fe35b6058"
    sha256 arm64_big_sur:  "0004d1a28d83410254c210d74f984e0fe3942a538a4b251f6651c0276841360b"
    sha256 monterey:       "ec171b0891c3ff221daa1f9505df4f658f56533d80901ea161291bcff1ea1114"
    sha256 big_sur:        "0dab96930b64dea3e2768f43050826f4fdf8246e83b93d6570691e698bc75186"
    sha256 catalina:       "b2b611924d4682c845381072c7e39f76806aa0f00e3b973aadf943193f6ff999"
    sha256 x86_64_linux:   "b7e0eb43c6c995d960813a26329282cbca7b5cda460a4c7acc6441d00e4012ee"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "osinfo-db"
  depends_on "usb.ids"

  uses_from_macos "pod2man" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "pci.ids" do
    url "https://raw.githubusercontent.com/pciutils/pciids/7d42acec647d327f0824260c2d4656410d48986a/pci.ids"
    sha256 "7e6314c5ecab564af740b1a7da0b2839690716344504420f19ae21bb8cf7ae9e"
  end

  def install
    (share/"misc").install resource("pci.ids")

    mkdir "build" do
      flags = %W[
        -Denable-gtk-doc=false
        -Dwith-pci-ids-path=#{share/"misc/pci.ids"}
        -Dwith-usb-ids-path=#{Formula["usb.ids"].opt_share/"misc/usb.ids"}
        -Dsysconfdir=#{etc}
      ]
      system "meson", *std_meson_args, *flags, ".."
      system "ninja", "install", "-v"
    end
    share.install_symlink HOMEBREW_PREFIX/"share/osinfo"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <osinfo/osinfo.h>

      int main(int argc, char *argv[]) {
        GError *err = NULL;
        OsinfoPlatformList *list = osinfo_platformlist_new();
        OsinfoLoader *loader = osinfo_loader_new();
        osinfo_loader_process_system_path(loader, &err);
        if (err != NULL) {
          fprintf(stderr, "%s", err->message);
          return 1;
        }
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libosinfo-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -losinfo-1.0
      -lglib-2.0
      -lgobject-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    system bin/"osinfo-query", "device"
  end
end
