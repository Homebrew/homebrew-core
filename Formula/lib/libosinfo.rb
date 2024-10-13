class Libosinfo < Formula
  desc "Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.11.0.tar.xz"
  sha256 "1bf96eec9e1460f3d1a713163cca1ff0d480a3490b50899292f14548b3a96b60"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?libosinfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "25a8b9d60fbc6c908da6f27684deb9b86ed49023ffa76ce2575af8e861c44d10"
    sha256 arm64_sonoma:   "5acd188d4c078e794e31e12701323a9d549c2db6dd09c0903060d3f5526378d6"
    sha256 arm64_ventura:  "ecbf5376391dd7932c61d6112f86cbdb2f7bf3f7f457694157abea71cdf289f9"
    sha256 arm64_monterey: "a7d126750cd6bc8fc8abb8433c3835da6ebfba0dbc0a8a6b19273648334f69c6"
    sha256 sonoma:         "9ae4b3ac7101c25433bafebdbfe01aa6ab8a3340173c426513fcf214a1ed14b8"
    sha256 ventura:        "6ddc2d382c032be8472373fa603c3b9b0d5238cc5e2219e736377c19d61df384"
    sha256 monterey:       "556d1cddbdc4c90e958754ee315c8f2e4f3b63ee59b5d00015debbf8bfc783ed"
    sha256 x86_64_linux:   "c17b5a93160795024c5be3de4e763140cf9aac0e14df7b396b5c480fbc83faf6"
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
  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "pci.ids" do
    url "https://raw.githubusercontent.com/pciutils/pciids/fd7d37fcca8edc95f174382a9a5a29c368f26acf/pci.ids"
    sha256 "3ed78330ac32d8cba9a90831f88654c30346b9705c9befb013424e274d2f3fbf"
  end

  def install
    (share/"misc").install resource("pci.ids")

    args = %W[
      -Denable-gtk-doc=false
      -Dwith-pci-ids-path=#{share/"misc/pci.ids"}
      -Dwith-usb-ids-path=#{Formula["usb.ids"].opt_share/"misc/usb.ids"}
      -Dsysconfdir=#{etc}
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

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
    system bin/"osinfo-query", "device", "vendor=Apple Inc."
  end
end
