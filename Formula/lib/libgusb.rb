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
    rebuild 2
    sha256 arm64_sequoia: "b5315217b63018e0935afaa911b71f26fb0dbd990a9496c97adb7a9a4837b1a0"
    sha256 arm64_sonoma:  "00eb752982e5b27777af8dfa4d83eb2396acf9d4612c89fd8a8c56e6e00d8ae5"
    sha256 arm64_ventura: "9753de67392b95353dd90f9e745d4343bb79fcec324884048fcf283e7034939c"
    sha256 sonoma:        "f4e98d60eed3f9d811415d82027560f3ca55945e17b78fafc961c56ee690915f"
    sha256 ventura:       "45c340c32f582a777d7a24667d7378e0b95d1043e32095cdb9356c8895fca893"
    sha256 arm64_linux:   "ffc70db16c18b845ad99a159902c8eb20397d38f38ff7d2f2f7842623923fa6f"
    sha256 x86_64_linux:  "ff05a0fdc15a300ceb4218458751283a54f691b12be3a627e98fdce3b218b7bd"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python-setuptools" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "json-glib"
  depends_on "libusb"
  depends_on "python@3.13"
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

    (testpath/"test.c").write <<~C
      #include <gusb.h>

      int main(int argc, char *argv[]) {
        GUsbContext *context = g_usb_context_new(NULL);
        g_assert_nonnull(context);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gusb").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
