class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libgusb.git", branch: "main"

  stable do
    url "https://github.com/hughsie/libgusb/archive/refs/tags/0.4.9.tar.gz"
    sha256 "aa1242a308183d4ca6c2e8c9e3f2e345370b94308ef2d4b6e9c10d5ff6d7763e"

    # add shebang patch for `contrib/generate-version-script.py`, upstream pr ref, https://github.com/hughsie/libgusb/pull/119
    patch do
      url "https://github.com/hughsie/libgusb/commit/371e851d4229d576e7c3e25a39a0f74449ad2ae3.patch?full_index=1"
      sha256 "cced0c66c9a91bb94b3cc02fe6740ecaf14cd2a8866f1d3e7a8af1378d25ffc8"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "f4bad548473caebb4b5b03ee300b7c166b1e43f9f6c7336065f01fc3a0063d9c"
    sha256 arm64_sonoma:   "83ac555e356ba4a1346d728424414da892d8b4693eb61c3e939aeb5830013f5f"
    sha256 arm64_ventura:  "f30ca967b5667b68650b83c13dbbeb9408847264f41360610db34a4925b3421e"
    sha256 arm64_monterey: "bc3aebd0f1043eeaa0b5b74ecaf344ac8b925cdffd427a315870ef47334f680d"
    sha256 sonoma:         "a429e31987ac68dd367e24bec5bb34ee03342b9d438e3f11cb5d2f7245924703"
    sha256 ventura:        "a4d2be814b655b27f7411afffbda19de4fc6c861b8f50d15b172130877c85be0"
    sha256 monterey:       "bb83a40b7d94d2dcd8757fe253d370f66e84218139e1ba165b71c78f6301714a"
    sha256 x86_64_linux:   "bd686b7dbf07628218465b63b67421110b24eb55e1a6d71a5aa422acb6fdd6c2"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python-setuptools" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "json-glib"
  depends_on "libusb"
  depends_on "python@3.12"
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
    system bin/"gusbcmd", "-h"

    (testpath/"test.c").write <<~EOS
      #include <gusb.h>

      int main(int argc, char *argv[]) {
        GUsbContext *context = g_usb_context_new(NULL);
        g_assert_nonnull(context);
        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs gusb").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
