class Libbpf < Formula
  desc "Automated upstream mirror for libbpf stand-alone build"
  homepage "https://github.com/libbpf/libbpf"
  url "https://github.com/libbpf/libbpf/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "7bda8187efc619d1eb20a1ba5ab949dd68d40dd44945310c91ac0f915fa4a42b"
  license "BSD-2-Clause"

  depends_on "linux-headers@5.16" => :test
  depends_on "elfutils"
  depends_on :linux
  depends_on "pkg-config"

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
