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
    rebuild 3
    sha256 arm64_tahoe:   "b72850ea01c8cd29ea25f54a76a4bc4fc30f04fef9a8c2deb858a767f32aed60"
    sha256 arm64_sequoia: "10c0f65e769b39908359972bacb28a546dba331e8ace790ccc1a0673fc936889"
    sha256 arm64_sonoma:  "d5152328e9ccc7008d88d58dfaa1e9d82e18d538f999341d266e7c30c8a13e1f"
    sha256 sonoma:        "f48eb8f462d0554baec1356735687801ab24af570a1de7d35d252147a0ebd67d"
    sha256 arm64_linux:   "de8939012f87fd944217bd85fdbdf9edacdb7505cfe6fac9cf2e6da70e41a257"
    sha256 x86_64_linux:  "8acc7113d4d8e45b58c64078881669fed44358d7d3d03fc9fc6852a66d5dca78"
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
  depends_on "python@3.14"
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
