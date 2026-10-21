class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libgusb.git", branch: "main"

  stable do
    url "https://github.com/hughsie/libgusb/archive/refs/tags/0.4.9.tar.gz"
    sha256 "aa1242a308183d4ca6c2e8c9e3f2e345370b94308ef2d4b6e9c10d5ff6d7763e"

    # add shebang patch for `contrib/generate-version-script.py`
    patch do
      url "https://github.com/hughsie/libgusb/commit/371e851d4229d576e7c3e25a39a0f74449ad2ae3.patch?full_index=1"
      sha256 "cced0c66c9a91bb94b3cc02fe6740ecaf14cd2a8866f1d3e7a8af1378d25ffc8"
      type :backport
      resolves "https://github.com/hughsie/libgusb/pull/119"
    end
  end

  bottle do
    rebuild 4
    sha256 arm64_golden_gate: "389de0b3db5ddb0555c809b918e138141cdc17ef20b734175454a97f80e39216"
    sha256 arm64_tahoe:       "9a924d348ebe1a2ff29eaed944df1cb686f800f03df3b9f542b945dea4142471"
    sha256 arm64_sequoia:     "6a247b6f7a80c357c0291050630e59923832d57940e8d44e19108a2b81a5f553"
    sha256 arm64_linux:       "130718400463ccd628a2235d2023cee9851918a3a7d2e1126a14c51f7247c5ed"
    sha256 x86_64_linux:      "17ab48f95b4e3968924c479edffab01ab97b942b8d32f752980b027700aae1ff"
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
  depends_on "python@3.15"
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
