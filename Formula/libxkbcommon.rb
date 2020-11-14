class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.0.1.tar.xz"
  sha256 "ab68b25341c99f2218d7cf3dad459c1827f411219901ade05bbccbdb856b6c8d"
  license "MIT"
  revision 1
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    rebuild 1
    sha256 "d13e68cce3b98b2aa427a33b7f19277efdb5b09061bbf09457dfb8f58baeb531" => :catalina
    sha256 "faa2d9bc12a5a7e1f56e1284abc06fcc795828f037ea9a0089f821f76e81d5fc" => :mojave
    sha256 "08c07cb44b08aa8e0f1703632dd5e87795e79ec25389f6c841cd4a84236f5963" => :high_sierra
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
      -Dxkb-config-root=#{HOMEBREW_PREFIX}/share/X11/locale
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
