class Libosinfo < Formula
  desc "Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.12.0.tar.xz"
  sha256 "ad8557ece26793da43d26de565e3d68ce2ee6bfb8d0113b7cc7dfe07f6bfc6b6"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?libosinfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "cf2259dd949ebcdd2cb0c9ea883d0f67abe07c351af73869cf6bfd300f24161f"
    sha256 arm64_sonoma:  "948b6a24382554b4f305e2273217f9e95e2928afc3df1819ce6ab37199c5d66e"
    sha256 arm64_ventura: "56c9fcb470ba6c18017696c84b0ac0efac45842166e440f6ce507102c167b964"
    sha256 sonoma:        "a9ddacdeac8d20b1a918ba60006a08eccc0d8b1b9296324eec944278a1a9aac1"
    sha256 ventura:       "44b619cc3c7a49a8ead42200b497313def8ea75111587cfcc97eced74b542293"
    sha256 arm64_linux:   "62838ed8c6d506a076cbd2cb1dbaef4ec846f15590fc6922fbb0fd20fe8214c4"
    sha256 x86_64_linux:  "42ed4e3587f00f42ac72e46d24c9baea274589e693f404d469297e7caf185b7f"
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
