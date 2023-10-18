class Libfuse < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https://github.com/libfuse/libfuse"
  url "https://github.com/libfuse/libfuse/releases/download/fuse-3.16.2/fuse-3.16.2.tar.gz"
  sha256 "f797055d9296b275e981f5f62d4e32e089614fc253d1ef2985851025b8a0ce87"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]
  head "https://github.com/libfuse/libfuse.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "ab801f94a42a4958defce2a4f5d06250c8bda2ef6262a08d858884fa94c3b69f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on :linux

  def install
    args = std_meson_args + %W[
      --sysconfdir=#{etc}
      -Dinitscriptdir=#{etc}/init.d
      -Dudevrulesdir=#{etc}/udev/rules.d
      -Duseroot=false
    ]
    mkdir "build" do
      system "meson", *args, ".."
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
