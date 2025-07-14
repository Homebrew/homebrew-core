class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.10.0.tar.gz"
  sha256 "0427585a4d6ca17c9fc1ac4b539bf303348e9080af70c5ea402503bc370a9631"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "5d111042432537f1ad4d4d63425952aa95478538525b0e3fc2a9d155b15e2f65"
    sha256 arm64_sonoma:  "1d95b2069b43ed380723f7d1e2fb31ba7c57f396a65e16115eea62b952b33486"
    sha256 arm64_ventura: "fac1aef344122665043d626d3e3f2b4399ba4f5b348c84d2a2b3c02b6f70ac62"
    sha256 sonoma:        "785a57898a7575ef47f599e6b2094f775ada2ba8884e01de8d02f062c99f6f9e"
    sha256 ventura:       "a34cffcd236e03c201601e646ed635d934de9d5cb556bc0154928d0e989de5d4"
    sha256 arm64_linux:   "cc2d7e6e184bd2b5566e8a8a1a756576a92d7fc5af99db5fc7c51ea2984ba147"
    sha256 x86_64_linux:  "0b3eae40f5f0fd0cdda9e88f6cba593a034b15ca7f312f7f34b5aec344f46baf"
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
