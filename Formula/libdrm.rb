class Libdrm < Formula
  desc "Library for accessing the direct rendering manager"
  homepage "https://dri.freedesktop.org"
  url "https://dri.freedesktop.org/libdrm/libdrm-2.4.114.tar.xz"
  sha256 "3049cf843a47d12e5eeefbc3be3496d782fa09f42346bf0b7defe3d1e598d026"
  license "MIT"

  livecheck do
    url "https://dri.freedesktop.org/libdrm/"
    regex(/href=.*?libdrm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "d4f9c979e3a78430d1679c592cf2641ce96851596fb119c36b3fe268d9812bb8"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libpciaccess"
  depends_on :linux

  def install
    system "meson", "setup", "build", "-Dcairo-tests=disabled", "-Dvalgrind=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libdrm/drm.h>
      int main(int argc, char* argv[]) {
        struct drm_gem_open open;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldrm"
  end
end
