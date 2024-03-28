class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.7.0.tar.xz"
  sha256 "65782f0a10a4b455af9c6baab7040e2f537520caa2ec2092805cdfd36863b247"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libxkbcommon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d4dc5666abb07f964a4ea2dcf8bed13d2a1a4ef8035c7001c3f176359d774fae"
    sha256 arm64_ventura:  "99e8ee1df3f8a3247bc3904f5f5fe1184067b2cb3a826fabcbaef70cf3249219"
    sha256 arm64_monterey: "bb99be852933c86dfd745e44ac46081140b1f21b9c02ad9fc31f663426384ebd"
    sha256 sonoma:         "72b44058453e2b5d75b576a9403647f0dc0d76dfd2b0a6cddd31f2e2fac779c9"
    sha256 ventura:        "83381d671ce4b07cf9232d06ec45e6e051d2090f8525a73f528544f3fa5b8e19"
    sha256 monterey:       "6958c8a61b2a62205cb3eae70ef088e3d3d2675a74e57bf7c35f23e6b2ee378f"
    sha256 x86_64_linux:   "3327f58e3610858e97b5675451c67ec2c7cadf16f34419292b4240186b5fa650"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "xkeyboardconfig"
  depends_on "xorg-server"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -Denable-wayland=false
      -Denable-x11=true
      -Denable-docs=false
      -Dxkb-config-root=#{HOMEBREW_PREFIX}/share/X11/xkb
      -Dx-locale-root=#{HOMEBREW_PREFIX}/share/X11/locale
    ]
    system "meson", *std_meson_args, "build", *args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
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
