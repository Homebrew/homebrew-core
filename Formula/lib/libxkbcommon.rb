class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.13.0.tar.gz"
  sha256 "cd9367eec501867dfe7ddc3f6b18a026f2a2844a89d19108448d376cb849c9ed"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "1996df0929403ff7182425a5e2e17e535c73097ec7deb9ac5f92119a23ff359a"
    sha256 arm64_sequoia: "44279dbd0522edc021b6b55a1dafcb22c05eca16e27ae86c295a901ed1bb50f5"
    sha256 arm64_sonoma:  "8acf39a656aee5cac594841891068c70ec1695bee61a5d34ca45ae38ae4cdf47"
    sha256 sonoma:        "05e881c1065522397e089aad20c16571294c1574262a98b57d388d8a267556bc"
    sha256 arm64_linux:   "97d1287883e9116cbabcd0e6b2d9d345f1bc31cd618ce1f38756cb12cf5c4f58"
    sha256 x86_64_linux:  "fced72698e7b9801503aa1016287fc0de3db1e6febc16151196f50db0805331c"
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
