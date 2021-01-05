class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.0.3.tar.xz"
  sha256 "a2202f851e072b84e64a395212cbd976ee18a8ee602008b0bad02a13247dbc52"
  license "MIT"
  revision 1
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    sha256 "b9690af727b2c7f9d21d233525d69931b4b167dca48ae2a8199a9f1955dffd5d" => :big_sur
    sha256 "cc43be6e1d1abb749ea93f341e31831364c5ea3f04e2db7ea32f7d448f4a8901" => :arm64_big_sur
    sha256 "5b76e52807e849d2ca9932ed7c0f7c6e73679bdd58d64315e5ce5e1c91c281a6" => :catalina
    sha256 "2a29cadcc1919e3b4d2775574d971ac45954b5c335194332c039b075aa42da5d" => :mojave
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
