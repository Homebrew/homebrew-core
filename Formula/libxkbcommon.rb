class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/releases/download/xkbcommon-1.1.0/libxkbcommon-1.1.0.tar.xz"
  sha256 "412cfcca596f92914ea1a66ad244804d73a5ff20b6d86459951e7ad20576c246"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    sha256 arm64_big_sur: "0a4c7b75bde5c7d0e2e1f1e83c4c9f05804c619e2e13fcbef4a1007dd46e04fc"
    sha256 big_sur:       "47c6a443070a0275f4dc4e8d648d2c7bb3bc1123fb38d9ba2888711c37590a05"
    sha256 catalina:      "a67d220b171537a97f4fe3d9537e478d60e11bdcadf2408cc4754342ae2fb31d"
    sha256 mojave:        "4939913b3093fa5b4b8e227b7441f97c55a94f779b193247170696eab9977ab8"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "xkeyboardconfig"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -Denable-wayland=false
      -Denable-docs=false
      -Dxkb-config-root=#{HOMEBREW_PREFIX}/share/X11/xkb
      -Dx-locale-root=#{HOMEBREW_PREFIX}/share/X11/locale
    ]
    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <xkbcommon/xkbcommon.h>
      int main() {
        return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
          ? EXIT_FAILURE
          : EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system "./test"
  end
end
