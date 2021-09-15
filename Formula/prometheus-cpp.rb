class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v0.13.0",
      revision: "342de5e93bd0cbafde77ec801f9dd35a03bceb3f"
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9c6b4056f435f518d70fc1901f4c2593e0e2ffef4beda73638eab341668b4b6b"
    sha256 cellar: :any_skip_relocation, big_sur:       "28c8ab9bdd974c1a0fca4aa0d35f8768bae2faa677456a496ab33882ab9f78f9"
    sha256 cellar: :any_skip_relocation, catalina:      "0237b5f568e0615a565599e8d39764035ed317f89862649394c82265be6095c2"
    sha256 cellar: :any_skip_relocation, mojave:        "37619f026ab8f9929a0d553bb4a2e3df5d66ef25826f32763d4f0d1cd94aee43"
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
      #include <prometheus/Registry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end
