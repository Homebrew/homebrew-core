class LibfuseAT2 < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https://github.com/libfuse/libfuse"
  url "https://github.com/libfuse/libfuse/releases/download/fuse-2.9.9/fuse-2.9.9.tar.gz"
  sha256 "d0e69d5d608cc22ff4843791ad097f554dd32540ddc9bed7638cc6fea7c1b4b5"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_linux:  "df8b668765d688eb5a516eaa67a73d1750b5ce6bab91b1924def3b7fd0d85aac"
    sha256 x86_64_linux: "2f5566126dd96e6a9c0329b6321db145d1815690cf5d4cf51d62b762493ca19b"
  end

  keg_only :versioned_formula

  # TODO: Remove `autoconf`, `automake`, `gettext`, and `libtool` when we no longer need the patch.
  # TODO: Consider generating a `configure` patch so that we don't need these.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on :linux

  # Fix build failure with new glibc.
  patch do
    url "https://github.com/libfuse/libfuse/commit/5a43d0f724c56f8836f3f92411e0de1b5f82db32.patch?full_index=1"
    sha256 "94d5c6d9785471147506851b023cb111ef2081d1c0e695728037bbf4f64ce30a"
  end

  # Backport fix for build failure on arm64. Debian applies same patch (0006-arm64.patch)
  patch do
    url "https://github.com/libfuse/libfuse/commit/914871b20a901e3e1e981c92bc42b1c93b7ab81b.patch?full_index=1"
    sha256 "97360b7353903f3968aa10c9fd95ee42372049fea748d2be78f1c054e750bed0"
  end

  def install
    ENV["INIT_D_PATH"] = etc/"init.d"
    ENV["UDEV_RULES_PATH"] = etc/"udev/rules.d"
    ENV["MOUNT_FUSE_PATH"] = bin
    # TODO: Remove `autoreconf` when patch is no longer needed.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--enable-lib", "--enable-util", "--disable-example", *std_configure_args
    system "make"
    system "make", "install"
    (pkgshare/"doc").install "doc/kernel.txt"
  end

  test do
    (testpath/"fuse-test.c").write <<~C
      #define FUSE_USE_VERSION 21
      #include <fuse/fuse.h>
      #include <stdio.h>
      int main() {
        printf("%d%d\\n", FUSE_MAJOR_VERSION, FUSE_MINOR_VERSION);
        printf("%d\\n", fuse_version());
        return 0;
      }
    C
    system ENV.cc, "fuse-test.c", "-L#{lib}", "-I#{include}", "-D_FILE_OFFSET_BITS=64", "-lfuse", "-o", "fuse-test"
    system "./fuse-test"
  end
end
