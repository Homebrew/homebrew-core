class Libosinfo < Formula
  desc "Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.12.0.tar.xz"
  sha256 "ad8557ece26793da43d26de565e3d68ce2ee6bfb8d0113b7cc7dfe07f6bfc6b6"
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?libosinfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "4112a597915e4822ba7f67beae18af91725b4ccce1771917ec0c9076201396c2"
    sha256 arm64_sequoia: "fe7b7b7c87405e3719fbde6309318ca2ab771116debb3ec7c2ad15b1d8463ab8"
    sha256 arm64_sonoma:  "ba5f315aa802a84fdd0bbffbb598dd15ba9e6a03e98224ebe2ee4753d18994c8"
    sha256 sonoma:        "019a2a7fa88fb2d781f03f9d91b084646e5b84cf2a324115006d7aa1d9d0a3b5"
    sha256 arm64_linux:   "5c3b5acf526dbbfd955c6e0e5642295fafce2b6048ba148162d71d0d419f7a1b"
    sha256 x86_64_linux:  "6009fdb51f4d951b99750674b9d62444427d0c39b6caaed385b29bb867d779c2"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libsoup"
  depends_on "osinfo-db"
  depends_on "usb.ids"

  uses_from_macos "pod2man" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
  end

  resource "pci.ids" do
    url "https://raw.githubusercontent.com/pciutils/pciids/fd7d37fcca8edc95f174382a9a5a29c368f26acf/pci.ids"
    sha256 "3ed78330ac32d8cba9a90831f88654c30346b9705c9befb013424e274d2f3fbf"
  end

  # Backport fix for libxml2 >= 2.14
  # Remove in the next release: https://gitlab.com/libosinfo/libosinfo/-/merge_requests/162
  patch do
    file "Patches/libosinfo/libxml2_deprecated_apis.patch"
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
    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs libosinfo-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    system bin/"osinfo-query", "device", "vendor=Apple Inc."
  end
end
