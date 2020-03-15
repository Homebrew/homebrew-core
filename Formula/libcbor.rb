class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "http://libcbor.org/"
  url "https://github.com/PJK/libcbor/archive/v0.6.0.tar.gz"
  sha256 "ad97dfe6462a28956be38c924a5a557acf303d8454ca121e02150a5b87e03ee7"

  bottle do
    cellar :any
    sha256 "8a4728ac8ec7eac79e8180f97e517e7c4c76fa5c0fd6d097f00732b248e886ff" => :catalina
    sha256 "397ef559af418180217ec90e70e62324ea226576e2ce75b86daa4405bba6fd57" => :mojave
    sha256 "7f5447e45af6348432021bac3912e0029904ae86a06f6945a77c78d119e40e36" => :high_sierra
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
