class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.13.2.tar.gz"
  sha256 "acc4d5f7c3cbba5f9f8d08d8bdbeede84ecede46792f47929aa9321873385528"
  license "MIT"
  compatibility_version 1
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "d68379f747f66e0041a1e787cd5681c44072ce5b86a2b6b1169f9e24b34eae8c"
    sha256 arm64_sequoia: "116a194f20417a009de9a754345472ec0bd3dbadac4281a02b3018a47986a4a4"
    sha256 arm64_sonoma:  "83909c4b3699b68e9032db0cb5255405b9b440dda27f4952b348c76fe8601dfe"
    sha256 sonoma:        "a5450a37c0e57d632a1de6af3f9dd137ab963de65b1e78348ab2c1e21b0e2fa7"
    sha256 arm64_linux:   "c7072e3f64685c1c0607cc972955f58c4869d75815a670fe582d45b3684337a6"
    sha256 x86_64_linux:  "b4d6c4be7f5c5c638cab5429f7b3bc7f11a809059c42e073b55e097b33202da3"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libxcb"
  depends_on "xkeyboard-config" => :no_linkage

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
