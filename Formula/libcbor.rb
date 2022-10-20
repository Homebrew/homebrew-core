class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/v0.9.0.tar.gz"
  sha256 "da81e4f9333e0086d4e2745183c7052f04ecc4dbcffcf910029df24f103c15d1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ebb91ce404c53552b9ec1f2a4800bc2c1a9e83cd1692d8b1e1612b4734b92925"
    sha256 cellar: :any,                 arm64_big_sur:  "53bf212a9f3fa8544360ad26e3eb574b80875ff3dac74193d9092d781b20286c"
    sha256 cellar: :any,                 monterey:       "d07e3853a1d2d1cabe8ac3f4c005a3d90226f9f5faa8d174f61c76b121a351cc"
    sha256 cellar: :any,                 big_sur:        "445ccae0ed1133be713e635c11e6591946e2df0345627db9214c10fdc0f9256b"
    sha256 cellar: :any,                 catalina:       "78b58702fde7659d633f12b176e8e2c1747b39616c218160f7f10697473adff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f103b611cf187099332e4cfe1638e261a35bd6181d3fadbfcb9daeadff734f"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_EXAMPLES=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
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
