class LibfuseAT2 < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https://github.com/libfuse/libfuse"
  url "https://github.com/libfuse/libfuse/releases/download/fuse-2.9.9/fuse-2.9.9.tar.gz"
  sha256 "d0e69d5d608cc22ff4843791ad097f554dd32540ddc9bed7638cc6fea7c1b4b5"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    sha256 x86_64_linux: "b13b4780fa7d33cd2e6fb7f55d44e693579264923381f934d417d108c0a246cc"
  end

  keg_only :versioned_formula

  depends_on :linux

  def install
    ENV["INIT_D_PATH"] = etc/"init.d"
    ENV["UDEV_RULES_PATH"] = etc/"udev/rules.d"
    ENV["MOUNT_FUSE_PATH"] = bin
    system "./configure", *std_configure_args, "--enable-lib", "--enable-util", "--disable-example"
    system "make"
    system "make", "install"
    (pkgshare/"doc").install "doc/kernel.txt"
  end

  test do
    (testpath/"fuse-test.c").write <<~EOS
      #define FUSE_USE_VERSION 21
      #include <fuse/fuse.h>
      #include <stdio.h>
      int main() {
        printf("%d%d\\n", FUSE_MAJOR_VERSION, FUSE_MINOR_VERSION);
        printf("%d\\n", fuse_version());
        return 0;
      }
    EOS
    system ENV.cc, "fuse-test.c", "-L#{lib}", "-I#{include}", "-D_FILE_OFFSET_BITS=64", "-lfuse", "-o", "fuse-test"
    system "./fuse-test"
  end
end
