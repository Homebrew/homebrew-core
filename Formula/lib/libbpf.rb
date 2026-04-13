class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://github.com/libbpf/libbpf/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "7ab5feffbf78557f626f2e3e3204788528394494715a30fc2070fcddc2051b7b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c568bbfccbfe4b8c0a9e4d10bce51e32bd0a016c99dcf74baf050e3cc73e1c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b097e3b166ab53800e559459b64a4167c8ebe57383f6e4cff627cf5ddbd14299"
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
