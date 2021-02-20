class Libfuse < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https://github.com/libfuse/libfuse"
  url "https://github.com/libfuse/libfuse/releases/download/fuse-2.9.8/fuse-2.9.8.tar.gz"
  sha256 "5e84f81d8dd527ea74f39b6bc001c874c02bad6871d7a9b0c14efb57430eafe3"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]
  head "https://github.com/libfuse/libfuse.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :linux

  def install
    ENV["MOUNT_FUSE_PATH"] = sbin
    ENV["UDEV_RULES_PATH"] = etc/"udev/rules.d"
    ENV["INIT_D_PATH"] = etc/"init.d"
    system "./configure",
      "--prefix=#{prefix}",
      "--disable-silent-rules",
      "--enable-lib",
      "--enable-util",
      "--enable-example",
      "--disable-rpath"

    system "make"
    system "make", "install"
    (pkgshare/"doc").install Dir["./doc/how-fuse-works", "./doc/kernel.txt"]
  end

  test do
    (testpath/"fuse-test.c").write <<~EOS
      #include <fuse.h>
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
