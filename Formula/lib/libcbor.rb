class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/v0.10.2.tar.gz"
  sha256 "e75f712215d7b7e5c89ef322a09b701f7159f028b8b48978865725f00f79875b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0c9da4fa78cfceac13e472381641e2606d5e717efff4b4ab4a4a016ba4e2ba28"
    sha256 cellar: :any,                 arm64_ventura:  "ee1e77e1e6cef7ba754d1757f7aa038e34b139466f789231b672e389a194a5fc"
    sha256 cellar: :any,                 arm64_monterey: "57f42308a7a0da1e7c5e7093669c0b860d83832903ec1233fad60ecd8ac92aeb"
    sha256 cellar: :any,                 arm64_big_sur:  "3f8fcacd05f809c68d133967f3485997d3864afd76c7ea8df4b00a6638cd71dd"
    sha256 cellar: :any,                 sonoma:         "59ab799eb5a658dac80c3f7c8a2f6adfcc59d7d6413ab100191085dd27673e73"
    sha256 cellar: :any,                 ventura:        "3c52d6c4828af57070d970dab0cfe3e174572c0eb6adf496c1cbdb54988cd97a"
    sha256 cellar: :any,                 monterey:       "5b1cc91f67025cfe899980d227fb0d14592635746e966b19307c9fc298f514e0"
    sha256 cellar: :any,                 big_sur:        "b748fb213e434fe650e0964d72f84275a5aac3620b336778dbdf578b5263df0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c532bdfe6b9efb37ff7cd43d1fcf2def27aefbffbea09093cecf16f95adc198"
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
      printf("Pretty-printer support: %s\\n", CBOR_PRETTY_PRINTER ? "yes" : "no");
      printf("Buffer growth factor: %f\\n", (float) CBOR_BUFFER_GROWTH);
    }
    EOS

    system ENV.cc, "-std=c99", "example.c", "-L#{lib}", "-lcbor", "-o", "example"
    system "./example"
    puts `./example`
  end
end
