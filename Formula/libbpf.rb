class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://github.com/libbpf/libbpf/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "5da826c968fdb8a2f714701cfef7a4b7078be030cf58b56143b245816301cbb8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9a904fba9aab6739edd75cec80c055aa7c8fcdeba114bf2f3cf9ef2096dd7a14"
  end

  depends_on "pkg-config" => :build
  depends_on "linux-headers@5.16" => :test
  depends_on "elfutils"
  depends_on :linux

  uses_from_macos "zlib"

  def install
    chdir "src" do
      system "make"
      system "make", "install", "PREFIX=#{prefix}", "LIBDIR=#{lib}"
    end
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
    system ENV.cc, "test.c", "-I#{Formula["linux-headers@5.16"].opt_include}", "-I#{include}", "-L#{lib}",
                   "-lbpf", "-o", "test"
    system "./test"
  end
end
