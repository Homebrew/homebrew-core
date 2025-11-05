class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.12.3.tar.gz"
  sha256 "b08bbd1ac6faef2b80774fbe22a0dda5563ef77480ad86677b51798bf0afef6d"
  license "MIT"
  revision 1
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "4c7b437c40ccf5deb9dcf8326058fda915bb076ed02a9431ebdb6e3939445b3b"
    sha256 arm64_sequoia: "3032fd60cf8eeed47400ac22c23725d9c74dd5cc85aed20a89598e7731c83952"
    sha256 arm64_sonoma:  "449f7aab7fe5593691dcb890149dcc1036d11bbdd6bb959ff681f276f08074fc"
    sha256 sonoma:        "6a6e79cc7d6ae801861fd33b69fb8069f01b40253f1e785b10de0de144e1a30b"
    sha256 arm64_linux:   "bcae305e7a29d939b53cbe4f0d11f8a1bd7f9064ffc33e691430e0e167952910"
    sha256 x86_64_linux:  "0404b0e467e2cff31d4139ac7a29c23d0b9653a0c5b3c6659b64b4df6bc92600"
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
