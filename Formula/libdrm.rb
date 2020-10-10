class Libdrm < Formula
  desc "Library for accessing the direct rendering manager"
  homepage "https://dri.freedesktop.org"
  url "https://dri.freedesktop.org/libdrm/libdrm-2.4.102.tar.xz"
  sha256 "8bcbf9336c28e393d76c1f16d7e79e394a7fce8a2e929d52d3ad7ad8525ba05b"
  license "MIT"

  livecheck do
    url "https://dri.freedesktop.org/libdrm/"
    regex(/href=.*?libdrm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libxslt" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libpciaccess"
  depends_on :linux

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libdrm_lists.h"

      int main(int argc, char* argv[]) {
        struct drmMMListHead *listHead;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldrm"
  end
end
