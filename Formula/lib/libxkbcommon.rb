class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.6.0.tar.xz"
  sha256 "0edc14eccdd391514458bc5f5a4b99863ed2d651e4dd761a90abf4f46ef99c2b"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libxkbcommon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a13ecda4aba3adbc8cfe1f9d61df8d1989a5980ebc9894e6bb3bf480374123fc"
    sha256 arm64_ventura:  "07edab1fe13db03f7d82d80284c3bf7b507b6613a1f4d8f5a2b4c2dcbf28c2c9"
    sha256 arm64_monterey: "d8ea4549721280adb007fadedaebb0bfbd4138ad6b7bd5bfc6c47cb4b7984948"
    sha256 sonoma:         "a83354b234ebbbe42a81ebd43d292dc65467350841f1bae38cda424484156063"
    sha256 ventura:        "a0e88782a77ab70eed79326dd717cef49a9ae17a9ed69f2f87595ab7b3cf7997"
    sha256 monterey:       "d5b36845c4a3a313335aa6cc08b4a4b1c8715d5d6738d38b0c45bbcb78002ad9"
    sha256 x86_64_linux:   "9c3ffb1a4833c13c148e2889ad7b509898ff80eca4cf8244391110917c599391"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "xkeyboardconfig"
  depends_on "xorg-server"

  uses_from_macos "libxml2"

  # upstream patch PR, https://github.com/xkbcommon/libxkbcommon/pull/468
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d074f6ee748fa7395ff76b91210229d22c04f185/libxkbcommon/1.6.0.patch"
    sha256 "942b1a2b7c912e234f902f1a780284b7cf02f05510f69d7edc2f2b75c13b8959"
  end

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
