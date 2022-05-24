class Libfuse < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https://github.com/libfuse/libfuse"
  url "https://github.com/libfuse/libfuse/releases/download/fuse-3.11.0/fuse-3.11.0.tar.xz"
  sha256 "8982c4c521daf3974dda8a5d55d575c988da13a571970f00aea149eb54fdf14c"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]
  head "https://github.com/libfuse/libfuse.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "ea609a3093702c051c16f7bd0bc1140fecdfa51a81b854445335cc3d94aaeb75"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on :linux

  # prevent libfuse from installing into /etc
  patch :p0 do
    url "https://raw.githubusercontent.com/conda-forge/libfuse-feedstock/fb966bfef17fa050eb0d2b819f7c6c06575962b9/recipe/0001-Install-fusermount-init-script-into-sysconfdir.patch"
    sha256 "ce2a512bbb1e7432c12e7c1c8fa97f07d9b6c1060bea90af8cb6ba5010b38a3c"
  end

  def install
    args = std_meson_args + %W[
      --sysconfdir=#{etc}
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
