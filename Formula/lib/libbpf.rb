class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://github.com/libbpf/libbpf/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "b7a1e685f90f6a63ead0dd85d053694b222975da8d09c1a966041cff6f0055ff"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_linux:  "0f59485aef544d9260217f4a9c34d35c20260b9bd025bf15e1e843d0a7f878f6"
    sha256 cellar: :any, x86_64_linux: "0e3b153bf3900e43906a552a465a539a9a0934af418a65c9848f79b23556080b"
  end

  depends_on "pkgconf" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib-ng-compat"

  def install
    system "make", "-C", "src"
    system "make", "-C", "src", "install", "PREFIX=#{prefix}", "LIBDIR=#{lib}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "bpf/libbpf.h"
      #include <stdio.h>

      int main() {
        printf("%s", libbpf_version_string());
        return(0);
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbpf", "-o", "test"
    system "./test"
  end
end
