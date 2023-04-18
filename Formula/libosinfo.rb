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
    sha256 arm64_ventura:  "b849e568f1debeed02519d9d5bf34072403397c1cc33998a238eb8daaf3eb09b"
    sha256 arm64_monterey: "2659892b2d277e688c8edc0f03875c1e518f5ab515a200d58698f717e9ed7dac"
    sha256 arm64_big_sur:  "e8f42ab6e678acb61213692e472cc233112067f87b9d10744c4db4a10e14729c"
    sha256 ventura:        "8ce2df8bcd25e66c828f766dc7de3055e03b0c28878b4c54153acc89fa9fd2e2"
    sha256 monterey:       "6fa3411b44dcdd8d33e73fa6d7b4e4d21828d0e00c52430c68684e9a0a2a45c6"
    sha256 big_sur:        "494af85f0b66b208db81e2114e492c683028ebe8c1748c61bfaaaa5b8fc7892f"
    sha256 catalina:       "ae3b5681f80d8a2fb8413b4d0e86ea64a4c6e48d809b9f96d2064ed1d7ecb570"
    sha256 x86_64_linux:   "eb8f140219fb3208a0ee34a0e412a6a4d24581e622e2d81cd269c2b10a8312e3"
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
