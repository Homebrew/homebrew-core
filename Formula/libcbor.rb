class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "http://libcbor.org/"
  url "https://github.com/PJK/libcbor/archive/v0.7.0.tar.gz"
  sha256 "fb731afe0a9980581d85e4b8d4ef128b175f782d92e0cd898935f3d26dd3dde7"

  bottle do
    cellar :any
    sha256 "9500d9ae8eb7c2048779c7be7c8be643f0f374ca131192c39f6f8ce4c4158173" => :catalina
    sha256 "8a1800894384b8c4a0a2f2190141754dfbdfb2cd56940ae87a7fb6ed704b06a2" => :mojave
    sha256 "6b42f6b810aa4e0cb0d5141491fa5b989413e518ed0134fd39677637999365e4" => :high_sierra
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
