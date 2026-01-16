class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://github.com/libbpf/libbpf/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "16f31349c70764cba8e0fad3725cc9f52f6cf952554326aa0229daaa21ef4fbd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "8f351d9e1b6a72b32a9c22cb57f58087c38eb4ac8ab012dce472d4221c2a431e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0108855ddc31e304bb92864440ea05c3dd26b44765cd851bda5667ba597be414"
  end

  depends_on "pkgconf" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib"

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
