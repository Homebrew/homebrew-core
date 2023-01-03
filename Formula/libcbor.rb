class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/v0.10.1.tar.gz"
  sha256 "e8fa0a726b18861c24428561c80b3c95aca95f468df4e2f3e3ac618be12d3047"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f28c88bc7f8d1f7151fdcfa5914e376243ec871023c55c35c93bc24132317dd"
    sha256 cellar: :any,                 arm64_monterey: "4e24385ee758d122aa94647b657cf2ad51b0b1f1b206c5b5c28584013ed46ddb"
    sha256 cellar: :any,                 arm64_big_sur:  "9f95e222a5ffe4ac89b36930851b6918d9b574e6d959b96c7fdeb02058aa2645"
    sha256 cellar: :any,                 ventura:        "d47430f5ed58a42c6062217d8c83dea5af4d6d1ff8c02a0c8ea9121cf7a9b027"
    sha256 cellar: :any,                 monterey:       "273d6d3a9fec6bfdaec5127bba7ed30804320bb17488042397a50e15e2f020e7"
    sha256 cellar: :any,                 big_sur:        "e4fd52516f99358858359b1acb624bb7242d272eb4697f6dc597470c772ef5c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc65c81bee78c14d16e99717e8700d93373c6782fddcc13f970036d9a129eda2"
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
