class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v1.2.3",
      revision: "4bd38da318ec54af8e2d8d5d0bdbd5eb9bc0784f"
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b611b4be621623c435c1007699868d5314725ff20b1077e93af93181fcd08fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37d9a7a09e4c6ce562ad2687702b4a16fc4fa657f3b08ee2b92f5906654c0c7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "434a050fa1496ac647044cbca54b32dbcedb26972a87b272550c092b18a12840"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4496955575abbb2f9707f5fb3901bf89d94f9f4602c96ebdd4180cd351175d2"
    sha256 cellar: :any_skip_relocation, ventura:        "e01ff1a61beee01bd0968b0c58f0c5030a5eadf4b1cf55ce86fc9ad5b7adcf45"
    sha256 cellar: :any_skip_relocation, monterey:       "aa6885bcf92df9dcffe593494431eb1e48a166505718c653859e68a095576b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe705f86f7112cfa7c4b99e6114c6c53b825b7df14473aa5ef84fe812f88d4fa"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <prometheus/registry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end
