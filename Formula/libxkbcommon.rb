class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.0.3.tar.xz"
  sha256 "a2202f851e072b84e64a395212cbd976ee18a8ee602008b0bad02a13247dbc52"
  license "MIT"
  revision 1
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    sha256 "64680f75763d17483d95ab7e60beb5190a04aa9c7586a938b35b4a15bbee479d" => :big_sur
    sha256 "0641f9d91a998367985625f2ab546db32dbb66f4e1a08ce04a317a1d8398182f" => :arm64_big_sur
    sha256 "e2c1dfba1e87800617b98cb440e15ca8d20fdec63c3591719ea8f74f8723727f" => :catalina
    sha256 "c341c13c34ded7f977c5c93e723abb647845f86f18e1880252a958854c375b4e" => :mojave
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
