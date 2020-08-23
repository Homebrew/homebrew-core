class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "http://libcbor.org/"
  url "https://github.com/PJK/libcbor/archive/v0.7.0.tar.gz"
  sha256 "fb731afe0a9980581d85e4b8d4ef128b175f782d92e0cd898935f3d26dd3dde7"
  license "MIT"

  bottle do
    cellar :any
    sha256 "592a8fe5ad2efd8111f016631ab251162e821e2a1560e42cd6285d60525b3813" => :catalina
    sha256 "104f1676b69dbcbbedb00c9059d1b08cf05f9003379fee323b9fba7728bb51fa" => :mojave
    sha256 "7f6b69a84c6c7ec111e7c0a8c2d086e5933a44268d1af20c5dd28eb5af60eccc" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_EXAMPLES=OFF", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"example.c").write <<-EOS
    #include "cbor.h"
    #include <stdio.h>
    int main(int argc, char * argv[])
    {
    printf("Hello from libcbor %s\\n", CBOR_VERSION);
    printf("Custom allocation support: %s\\n", CBOR_CUSTOM_ALLOC ? "yes" : "no");
    printf("Pretty-printer support: %s\\n", CBOR_PRETTY_PRINTER ? "yes" : "no");
    printf("Buffer growth factor: %f\\n", (float) CBOR_BUFFER_GROWTH);
    }
    EOS

    system ENV.cc, "-std=c99", "example.c", "-L#{lib}", "-lcbor", "-o", "example"
    system "./example"
    puts `./example`
  end
end
