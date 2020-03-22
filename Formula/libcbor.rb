class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "http://libcbor.org/"
  url "https://github.com/PJK/libcbor/archive/v0.6.0.tar.gz"
  sha256 "ad97dfe6462a28956be38c924a5a557acf303d8454ca121e02150a5b87e03ee7"

  bottle do
    cellar :any
    sha256 "59b70681658d5173ec44c8bc6ae56bc714287d599b4df7a8582f2fd62d62d002" => :catalina
    sha256 "953ac4ba8d331b0689107f085da72083fccbf20420773819bfb6153243c3f195" => :mojave
    sha256 "1ca2a0383d4281b6a6a52e55459345fdd82d1183eb5c9ad4f5f431de5c079297" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "..", *std_cmake_args
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
