class Libosinfo < Formula
  desc "Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.9.0.tar.xz"
  sha256 "b4f3418154ef3f43d9420827294916aea1827021afc06e1644fc56951830a359"
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?libosinfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "628d18923f168d2ed454a5a6c3aacc9408f2f009046cee2c84ac7a872b66e428"
    sha256 big_sur:       "c1eeea184883a96849938c8b71908bb8e5ebc4985c9b958f9671205a11199928"
    sha256 catalina:      "c6423c62d06368ee03080aafaabefced7ddfd6c014c00ffddfab738e8aa76fad"
    sha256 mojave:        "a0ecd6371b9940ee2c73b818cbeb1df7a001c4a4dea0508df2e4e2e885412881"
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
    url "https://raw.githubusercontent.com/pciutils/pciids/7906a7b1f2d046072fe5fed27236381cff4c5624/pci.ids"
    sha256 "255229b8b37474c949736bc4a048a721e31180bb8dae9d8f210e64af51089fe8"
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
