class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://github.com/libbpf/libbpf/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "989ed3c1a3db8ff0f7c08dd43953c6b9d0c3ac252653a48d566aaedf98bc80ca"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c6434f21ee8213728fa2282fa9c7212576b6b930c04fb89080184693d597cca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "82f1148d37fd262f39b42d8a3edb7f152e2028c6fd39efad34117b8a10b2a3d0"
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
