class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.0.2.tar.xz"
  sha256 "0ea2f88f4472bbf8170c5a7112f5af8848a908ca15df9e9086c3de0189612b2b"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    sha256 "eba7e1822c399b6a0e71e91b6a17248817f0a8f205cb6498068c971980546769" => :big_sur
    sha256 "bf2346f444e3c8dcf1b34a08abeb5142eb07019a14c1513638df8e4b60c7acef" => :catalina
    sha256 "57e4659ca526ee0b579a35f4eb7ab4a97d56631ec17f5320cd662d3379c92521" => :mojave
    sha256 "01e3b905b6e11da0fd02674ae5e659659a2019bc4a99c8d874ceb2dc3daa7610" => :high_sierra
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
