class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.8.0.tar.xz"
  sha256 "49ff32be0d209f6c99480e28b94340ac3dd0158322ae4303adfbdfe973a108a5"
  license "GPL-2.0"
  revision 2

  bottle do
    sha256 "1f37bf2e3ff5b94f183416806b0cd5ea8c21cf1de87d28bf1e84ae9d4d298d04" => :catalina
    sha256 "1dc3cbb1db1d2f93eaef7d152098f59d4d77fb00d75630b20d19d2f987d466e0" => :mojave
    sha256 "03834a6421253463aa1b47d6b39d1bef80e489490939904ff74b4ddc50012fdf" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "libxml2"

  resource "pci.ids" do
    url "https://pci-ids.ucw.cz/v2.2/pci.ids.gz"
    sha256 "09dc9980728dfeb123884ecedf51311f6441ffa8c5fa246e4cbea571ceae41b7"
  end

  resource "usb.ids" do
    url "https://deb.debian.org/debian/pool/main/u/usb.ids/usb.ids_2020.06.22.orig.tar.xz"
    sha256 "d55befb3b8bdb5db799fb8894c4e27ef909b2975c062fa6437297902213456a7"
  end

  def install
    (share/"misc").install resource("pci.ids")
    (share/"misc").install resource("usb.ids")

    mkdir "build" do
      flags = %W[
        -Denable-gtk-doc=false
        -Dwith-pci-ids-path=#{share/"misc/pci.ids"}
        -Dwith-usb-ids-path=#{share/"misc/usb.ids"}
        -Dsysconfdir=#{etc}
      ]
      system "meson", *std_meson_args, *flags, ".."
      system "ninja", "install", "-v"
    end
    (share/"osinfo/.keep").write ""
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
