class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.11.0.tar.gz"
  sha256 "78a6b14f16e9a55025978c252e53ce9e16a02bfdb929550b9a0db5af87db7e02"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "74daac8c286d22a6d974c491a76d1b72392db319724e03797bd76efe862d5f90"
    sha256 arm64_sequoia: "168d01c1766767fb40d0a6e002fc69e257b222acd314b94516d87274f05e5392"
    sha256 arm64_sonoma:  "a91f72579a536b89c7ca1535af9b77ce7441b95f0323e957a05df4ec17af6712"
    sha256 arm64_ventura: "e6cddacec36cad7930ddbc1893354b1f572f906b62f7320a1dc0012ac4cb5684"
    sha256 sonoma:        "88553315f7fe6bf3ad49abd0395a9bd61492f6e54dd3ba26e1a158cb1453090a"
    sha256 ventura:       "bd999fe74568dc59bb165d1991fd9eb69902221a1d42663ecc716a02f6c90109"
    sha256 arm64_linux:   "477d530047eca4f96cdd58d3fb5664a4794af48a7df638bb049666cf1ccdcb88"
    sha256 x86_64_linux:  "d82ee02d787b5775e685fa520fba687918207197150ce4c36b2a057225ded951"
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
