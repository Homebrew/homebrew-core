class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.10.0.tar.xz"
  sha256 "57c3630cdc38fb4734cd57fa349e92244f5ae3862813e533cedbd86721a0b6f2"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    cellar :any
    sha256 "3bb1cdd87e14a36a47ee65bab56c9182f772cdf1b9f4147bc2fe95f7a916a6d1" => :catalina
    sha256 "d6ed444a792d3752ffa009f5211001be4689e6d8d1990597037143b8704f6d7d" => :mojave
    sha256 "999abf2655e5bc7ec209937b02e8377e626f940e9f506c57e3d0e78436696cde" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on :x11

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Denable-wayland=false", "-Denable-docs=false", ".."
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
