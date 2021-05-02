class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.3.0.tar.xz"
  sha256 "7b09e098ea69bc3054f0c57a9a25fda571c4df22398811606e32b5fffeb75e7b"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    sha256 arm64_big_sur: "270a5400092c864f4d232b3b98d8d021a6a177ccb4eb42a70c92dc6da437bab1"
    sha256 big_sur:       "07bfb4c4d2ababedad929051d836fa8a1b86b444d061ed613e3bdf5f7448e8be"
    sha256 catalina:      "3dfcace9096eb252a09258e1754a63aad56a4c2adab793311b22ed899e3bb227"
    sha256 mojave:        "8bfd0b4896fe5295b4e4d5e1f967106078ced64f517dc31242376e0b185f86c9"
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
