class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.0.3.tar.xz"
  sha256 "a2202f851e072b84e64a395212cbd976ee18a8ee602008b0bad02a13247dbc52"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    sha256 "d4e9211bfc902cd0a6372a6473085f038fa2d3e6c05c1b0702b0d4d58c0b7927" => :big_sur
    sha256 "0748e8b4cce032d324934a8f59dc15e6b8d1f36b1f25279b51322ce2251cd117" => :catalina
    sha256 "43ef3c8d208439a768824fcaed0227e9ce4cafb18c983308d4711cf318a0b307" => :mojave
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
