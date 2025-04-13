class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://github.com/libbpf/libbpf/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "53492aff6dd47e4da04ef5e672d753b9743848bdb38e9d90eafbe190b7983c44"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "96c808c8f6a5b908a3a1702404a7461f8ce9981173f937a45ee0ef1adef9dd5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ff0139bb799097722a2a15a5593ebb0c6e13ba2e8f61f8add855bef223329c33"
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
