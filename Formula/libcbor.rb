class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/v0.10.1.tar.gz"
  sha256 "e8fa0a726b18861c24428561c80b3c95aca95f468df4e2f3e3ac618be12d3047"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b51b6f694a864edcbb46b6b83f6ad7e9582052c548f8f64ed48b7b08529acdc7"
    sha256 cellar: :any,                 arm64_monterey: "4a5aed35918777e9f7f2eee9ba8379f1fe24e9b9f032efda2e8896c5b02bb512"
    sha256 cellar: :any,                 arm64_big_sur:  "dba22eee5247f8c6edf1ead8da5e81ef6d35792ad6a6f1e58fc0e77cd37bceca"
    sha256 cellar: :any,                 ventura:        "9ce1d1fa60c374d819d33034770e82c932ab22ab70a81891d1e78386beed4a70"
    sha256 cellar: :any,                 monterey:       "9589ab0d1d316a5b79703b5cc4a60009da409ca19794aa9f8d001d6765deeef2"
    sha256 cellar: :any,                 big_sur:        "48a1c51fb6d7e8fd1a68d0ca8afb0b19b9d89f85a33d5daae85bd987d20ec9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b406cc3753624c32540a9227575bb5c9e11454a65fb69d091342359aeed6ca2f"
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
