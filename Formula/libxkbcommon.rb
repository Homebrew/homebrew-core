class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.10.0.tar.xz"
  sha256 "57c3630cdc38fb4734cd57fa349e92244f5ae3862813e533cedbd86721a0b6f2"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    cellar :any
    sha256 "4cdb1253e94b84d437d265c6e7c893c0bd4ab250de217c1326bc7192917dd53b" => :catalina
    sha256 "d3f1d57e7ac3f00e3ddf5b95f24446ea09b254d880757ca928ab6f3873aad215" => :mojave
    sha256 "d9faf6a0432c5c26d3245d401899ee7a4230eade04cdd36995fa49748d1a8a62" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on :x11

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Denable-wayland=false", "-Denable-docs=false", ".."
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
