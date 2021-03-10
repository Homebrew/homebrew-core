class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://github.com/xkbcommon/libxkbcommon/releases/download/xkbcommon-1.1.0/libxkbcommon-1.1.0.tar.xz"
  sha256 "412cfcca596f92914ea1a66ad244804d73a5ff20b6d86459951e7ad20576c246"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    sha256 arm64_big_sur: "0641f9d91a998367985625f2ab546db32dbb66f4e1a08ce04a317a1d8398182f"
    sha256 big_sur:       "64680f75763d17483d95ab7e60beb5190a04aa9c7586a938b35b4a15bbee479d"
    sha256 catalina:      "e2c1dfba1e87800617b98cb440e15ca8d20fdec63c3591719ea8f74f8723727f"
    sha256 mojave:        "c341c13c34ded7f977c5c93e723abb647845f86f18e1880252a958854c375b4e"
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
