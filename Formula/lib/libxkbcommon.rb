class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.9.1.tar.gz"
  sha256 "763b914c4779e9579ab4d06caffff39cc8f43a1c126ec3b7a2f920bf9817097b"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "79d066f81638b958b96bc97af6a5dda82860a1c887e6246ff401267e4997c26e"
    sha256 arm64_sonoma:  "d8be3355dff319cab7734ad993e31e1e8457864e5aab99f102bd01b6a02a3ed4"
    sha256 arm64_ventura: "cfaa6c4d9363c6bc7f55a41388d685ae3e8b39e769477bfe86d0a556ae7bde05"
    sha256 sonoma:        "b9174b8682500010483bce3e0546e5265c0edc29f32fef8a7a2407643e1fc8d7"
    sha256 ventura:       "528f1e5e245bed160a90fb00c714265d433a36d771bf592afc2cf0a90b426d49"
    sha256 arm64_linux:   "e900ec332ec6cbcd610a78ca2f43f12a249c1083105cb68ef70c8c590e9f6e0a"
    sha256 x86_64_linux:  "c135e43785643068e63dd5f16d623ceec66807b433f29c3189b41657eacfe5f9"
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
