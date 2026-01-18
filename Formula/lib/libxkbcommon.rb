class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.13.1.tar.gz"
  sha256 "aeb951964c2f7ecc08174cb5517962d157595e9e3f38fc4a130b91dc2f9fec18"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "b3ed10e5f7df8fc19afc02a50ee79ae13417359214bf517b95020af18d0ac8ee"
    sha256 arm64_sequoia: "460f8264639fdbb80451252d5dc70f731e46f4587b15dccbe487e6248cf5d439"
    sha256 arm64_sonoma:  "0ff01cd751c19985b6cb9dce8da5a247606f05b403311cd0537389e69ff5d93b"
    sha256 sonoma:        "fe537a2c8f25c11af6015930b3f9b5145416a15e51dcc4ed7565a02546828bd7"
    sha256 arm64_linux:   "bce2de8042eb4c07a8b83730d3ed5ac0d8588af1b9efa8046a98f30f3213ec0b"
    sha256 x86_64_linux:  "f57e780a55d512773318d422adabf4d01e3b312d61c6c8437b50eec034e2b787"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libxcb"
  depends_on "xkeyboard-config"
  depends_on "xorg-server"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -Denable-wayland=false
      -Denable-x11=true
      -Denable-docs=false
      -Dxkb-config-root=#{HOMEBREW_PREFIX}/share/X11/xkb
      -Dx-locale-root=#{HOMEBREW_PREFIX}/share/X11/locale
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <xkbcommon/xkbcommon.h>
      int main() {
        return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
          ? EXIT_FAILURE
          : EXIT_SUCCESS;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system "./test"
  end
end
