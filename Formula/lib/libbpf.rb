class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://github.com/libbpf/libbpf/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "d4cf3ee697d9bd959ad3c0f5c6757370a2559e54448761271e15a23c31c1082e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ad5dbfb644e5d111281dcc478dc41e6500180bf1d51484ce76c1baefe2ae16a9"
  end

  depends_on "pkg-config" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib"

  def install
    system "make", "-C", "src"
    system "make", "-C", "src", "install", "PREFIX=#{prefix}", "LIBDIR=#{lib}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "bpf/libbpf.h"
      #include <stdio.h>

      int main() {
        printf("%s", libbpf_version_string());
        return(0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbpf", "-o", "test"
    system "./test"
  end
end
