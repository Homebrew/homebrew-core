class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "4b0638061a789a1efbefdcd2e85eb257c7b432b3b6a71ba8909e19d75f50b163"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a3870ad069946d15ecc4a9277abb53f537704f0bff97c513c0555147307ad96"
    sha256 cellar: :any,                 arm64_sonoma:  "babcfa25adcc7751b653dac1df07392d4366f0dabf7e0a3bd7d0cf4d19d9eaac"
    sha256 cellar: :any,                 arm64_ventura: "254925ab3e63d3a1e3446d481a1bcb94ea832386dc039b98da8221dbd3000d8e"
    sha256 cellar: :any,                 sonoma:        "1cda78cd98975d6a09429d16c1ce69ba8d6ae2f55cbdc2a58eeb1f0d17c584d1"
    sha256 cellar: :any,                 ventura:       "5ae520034af5413e29d35a8e74abc1a11e7e7dac16c078db757266d2d418ae2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d79c96332e57b65c385bedd7aa95ca82ecc33616c7b7485ab8a3f0cb24e9e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d298110a7fff028faebc21047f71344eb13b5d5464b076b7853ad32e141086b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <oneapi/dnnl/dnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system "./test"
  end
end
