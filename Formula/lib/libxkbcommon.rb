class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.8.1.tar.gz"
  sha256 "c65c668810db305c4454ba26a10b6d84a96b5469719fe3c729e1c6542b8d0d87"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "e17a7165d667abfde67eeaa55201022f41f070d603b35be24f06675ff729c83d"
    sha256 arm64_sonoma:  "6d73b7fe3cc56ed4bf9423dbc3169e0ee71de814446c672dfb0d813140c7f66b"
    sha256 arm64_ventura: "32d6a4a4c35d77fcf33d9d11b056fe44bced10436d776304a89fee455460c6df"
    sha256 sonoma:        "8d90850aee4b259ff81c341de91f048da624ed6821113f4513ab9a669a0b23f3"
    sha256 ventura:       "db65eb514edb1dd5fb91987846c63b67cdeb9c151d653fa65e3f67202d82ef68"
    sha256 arm64_linux:   "fcb10ceb2f2b110280252f72895c40c79bef04be7230c7a11fb7a0e18ef879b5"
    sha256 x86_64_linux:  "2613c577fd0374fcadc3f5d5123408f980c94e4b8e46f53dee14f80a9c2b853d"
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
