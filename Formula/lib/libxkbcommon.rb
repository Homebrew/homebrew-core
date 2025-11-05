class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.12.3.tar.gz"
  sha256 "b08bbd1ac6faef2b80774fbe22a0dda5563ef77480ad86677b51798bf0afef6d"
  license "MIT"
  revision 1
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "c373381a668bb08c02029141f4bc69560c46d9ec5c23c7df3a3cb629a9dad7c7"
    sha256 arm64_sequoia: "e2b6d1418cd08f1ca8db11cc0c11658d756e51b3cd156f336c8cdee073876720"
    sha256 arm64_sonoma:  "feda05d7dd1a819d84e9ee7dbebd362c526a3c395484b00557be45188cf41396"
    sha256 sonoma:        "7a4a688472778bbc74a6bfb85f08e54f9fc94fff2dc91f55f4fdfb7eec03e16c"
    sha256 arm64_linux:   "134c8eea78b42208970ded161e327d215371a51591127eafcc1603b06b091922"
    sha256 x86_64_linux:  "3e6d884ec8e184ac4ff96dea793acdf1b669ad6894a5f70808b792f714e97ffc"
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
