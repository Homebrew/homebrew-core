class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "b643ca0cb1a8fb8832124062ed4d3f31200f72f691423c6f8b64184a16606cd8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bd03d105148fd0d49ffbf6b8ac9b32e56c559a92ae55647d8999d14714486659"
    sha256 cellar: :any, arm64_sequoia: "5ef82c9afd07257e91246eed357fd062818c5af7683b2ce4783754dec3b2e8e2"
    sha256 cellar: :any, arm64_sonoma:  "fd8e721edb17dcd71d4c337aa451e5d01cca6f23168d5bbd9020651211c75cc1"
    sha256 cellar: :any, sonoma:        "a407602d0f57635da226ad915a00ab7dbe300107f2ed764408cec0a350813a5b"
    sha256 cellar: :any, arm64_linux:   "e24c09aec039d167286a8a936a3be5a9ad6451231d643e95f1d45c1f4ec2ffff"
    sha256 cellar: :any, x86_64_linux:  "8c8b9bab447ed04d1ec6dc7462df018453576fac0c3ef021c8152f208cba6313"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{include}/re", "-L#{lib}", "-lre"
    system "./test"
  end
end
