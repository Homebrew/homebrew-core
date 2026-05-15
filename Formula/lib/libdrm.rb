class Libdrm < Formula
  desc "Library for accessing the direct rendering manager"
  homepage "https://dri.freedesktop.org"
  url "https://dri.freedesktop.org/libdrm/libdrm-2.4.133.tar.xz"
  sha256 "fc68f9d0ba2ea63c9432a299e14fea09fad7a8a66e8039fcd7802ca59f77b4f5"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://dri.freedesktop.org/libdrm/"
    regex(/href=.*?libdrm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "8baed75aebc0b0adfa126a3aa6e9d96e44dd8274fdde4aac1d904dd83db636bd"
    sha256 x86_64_linux: "aa9a8667102945ed386d63f42213591df43d52fa7b65d4613bd1389790ffa059"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libpciaccess"
  depends_on :linux

  def install
    system "meson", "setup", "build", "-Dcairo-tests=disabled", "-Dvalgrind=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libdrm/drm.h>
      int main(int argc, char* argv[]) {
        struct drm_gem_open open;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldrm"
  end
end
