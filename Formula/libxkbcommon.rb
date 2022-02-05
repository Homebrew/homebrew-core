class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.4.0.tar.xz"
  sha256 "106cec5263f9100a7e79b5f7220f889bc78e7d7ffc55d2b6fdb1efefb8024031"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libxkbcommon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a75c6677a5c45eabcd73867086dff4c704900ac9cf6ce8e26dd1be5a6ff1157a"
    sha256 arm64_big_sur:  "4de98d422442bc15aaf7b0e78f2c4312c1ae73a12eb48e87c051b0cffc5db57c"
    sha256 monterey:       "c6b33b38933fc09c5b8759976f24ce1c556cd56a62e8e1504173016e1ff665f5"
    sha256 big_sur:        "8c90166b1335ba095d76506b61a9cdfb97e67b9a603da2654fcca8328a2429a6"
    sha256 catalina:       "ac9c4b144d43a06ea024febda54a957490b0d985156adeee86fc4358288ade84"
    sha256 x86_64_linux:   "a691f0e653cae432d021079871bbe82589b9614248973b81191e1c5ab93845ba"
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
