class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.3.1.tar.xz"
  sha256 "b3c710d27a2630054e1e1399c85b7f330ef03359b460f0c1b3b587fd01fe9234"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    sha256 arm64_big_sur: "4d90728ce58c3e91ceb8f184bf78b0dcde24b8d80f64820f788f116d4d621ba8"
    sha256 big_sur:       "d70f333837f2e6f3c4ff279c8a5811fde4ac7fc7ee20c01f71531ffc669a7ce5"
    sha256 catalina:      "91d714d117af4e8b2c8c6a044b32dbcb4d88afe8fcf8eab44060e3025e4c5da0"
    sha256 mojave:        "366af8c0fc612df3d5dd13aee882a46e4d962299b62fccc0de3a5ec903bf24de"
    sha256 x86_64_linux:  "3f8c39c75716d2fd4bb13e041b9cc0de39c47fb19959f377b101008905721beb"
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
