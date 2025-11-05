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
    sha256 arm64_tahoe:   "4773ff32945a3d4c0b60862f9d922197cccd51007e8ef68be8406a1d47377d83"
    sha256 arm64_sequoia: "007bbf084f955d4977136156f0a4b04ab76b5b78c28c7c4312b56a100470696f"
    sha256 arm64_sonoma:  "f80f6cb7e7e20720683e5f4acbbb0a8b18888cd45d8e86c8dfb85c8c11578947"
    sha256 sonoma:        "8695c32adedebb47e0193b2630bf5e4be7face356688702edd6fcd3cf2100c5d"
    sha256 arm64_linux:   "4f2544454bcb943bb021c39e9533262b1c1384f86cbd642f192f036e5ba7aaa5"
    sha256 x86_64_linux:  "c543a59fcf39583b1f55839d2ec00ea5575aa88b8956ed86e0a284131411dacd"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
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

  # Backport fix for libxml2 >= 2.14
  patch do
    url "https://gitlab.com/libosinfo/libosinfo/-/commit/0adf38535637ec668e658d43f04f60f11f51574f.diff"
    sha256 "19fd45d55549decb981a6c1d83e4c8177eab88054ec545e4d97b63ab787df4d0"
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
