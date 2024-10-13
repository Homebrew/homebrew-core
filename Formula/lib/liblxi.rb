class Liblxi < Formula
  desc "Simple C API for communicating with LXI compatible instruments"
  homepage "https://github.com/lxi-tools/liblxi"
  url "https://github.com/lxi-tools/liblxi/archive/refs/tags/v1.21.tar.gz"
  sha256 "0ed6ddc2caeaf292c05a3d80fadf0ea0776187ec609fd3874f6dbbb411cda7e3"
  license "BSD-3-Clause"
  head "https://github.com/lxi-tools/liblxi.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ba9f08d2c888fe83b95ee04bed636183570284335d9693b07deab14d5476f34b"
    sha256 cellar: :any, arm64_sonoma:  "cafd14a894fe716196c2b384aa987466957ac95b17053cdae6c766466c560f12"
    sha256 cellar: :any, arm64_ventura: "c542b037f1b237279be7d71ee0bf32b256164decf6c51f94d2d246aee6547719"
    sha256 cellar: :any, sonoma:        "f490d08a779989026b594df8b93927a4d447c3b1f1be3124efce5526d171a785"
    sha256 cellar: :any, ventura:       "af9a495a33df338841d3eb69ef146300c7782c132fb95e5a8168c1e17fa8d7af"
    sha256               x86_64_linux:  "95c49c316da10f9a64559a1ae6d85f3eac043227d275f68196c696a29c167cb7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"

  on_linux do
    depends_on "libtirpc"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lxi.h>
      #include <stdio.h>

      int main() {
        return lxi_init();
      }
    EOS

    args = %W[-I#{include} -L#{lib} -llxi]
    args += %W[-L#{Formula["libtirpc"].opt_lib} -ltirpc] if OS.linux?

    system ENV.cc, "test.c", *args, "-o", "test"
    system "./test"
  end
end
