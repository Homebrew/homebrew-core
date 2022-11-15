class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.4.1.tar.xz"
  sha256 "943c07a1e2198026d8102b17270a1f406e4d3d6bbc4ae105b9e1b82d7d136b39"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libxkbcommon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b6191d46b43611e07b70881a1655421d274cc9e685936034dc52ae7886e4cc8f"
    sha256 arm64_monterey: "8f11c9d436064406b0c4cc5e8bc273561993433ebb64761bd9dea036b0ffd159"
    sha256 arm64_big_sur:  "e6a0c1aee452be0f17cd42f440daa9a5fa81cca5e1f07136de35480202755770"
    sha256 ventura:        "c7e002f3f0d6eb2fb8e16ed2797484d145f735ac94d009ee124c7de1ce356557"
    sha256 monterey:       "d3f1e8583b9a4519c4e0a166f7da02f768362059e1baa6ea4921028d40b1a2b0"
    sha256 big_sur:        "d085ec9717e7916089651d269602858839f15a7a284d59f880a3b116db2aa491"
    sha256 catalina:       "bfb9c00bd0398afa355e9c5b22799e9bf19f08f51b4f739b008067c660c9212c"
    sha256 x86_64_linux:   "11a40e4268f7366aaf314e3a1aead9860331a4ebd50667f40b442ea159071849"
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
