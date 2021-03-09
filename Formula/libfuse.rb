class Libfuse < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https://github.com/libfuse/libfuse"
  url "https://github.com/libfuse/libfuse/releases/download/fuse-3.10.2/fuse-3.10.2.tar.xz"
  sha256 "736e8d1ce65c09cb435fbbb500d53dc75f4d6e93bd325d22adc890951cf56337"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]
  head "https://github.com/libfuse/libfuse.git"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on :linux

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dudevrulesdir=#{etc}/udev/rules.d", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    (pkgshare/"doc").install "doc/kernel.txt"
  end

  test do
    (testpath/"fuse-test.c").write <<~EOS
      #define FUSE_USE_VERSION 31
      #include <fuse3/fuse.h>
      #include <stdio.h>
      int main() {
        printf("%d%d\\n", FUSE_MAJOR_VERSION, FUSE_MINOR_VERSION);
        printf("%d\\n", fuse_version());
        return 0;
      }
    EOS
    system ENV.cc, "fuse-test.c", "-L#{lib}", "-I#{include}", "-D_FILE_OFFSET_BITS=64", "-lfuse3", "-o", "fuse-test"
    system "./fuse-test"
  end
end
