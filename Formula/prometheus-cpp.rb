class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v0.12.2",
      revision: "2412990ee9ad89245e7d1df9ec85ab19b24674d3",
      shallow:  false
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ff27c5b8c09e2707840457fe5a0995ea2012e5638cf2872dcbf50e972f44a1f"
    sha256 cellar: :any_skip_relocation, big_sur:       "18ff7233d38197c84da22d1a9d59dc5fd086b91051ae6c8c5f3a0458dfc5a4fd"
    sha256 cellar: :any_skip_relocation, catalina:      "24aeac3a5c0424ec2ce6fd031d719a7d01bb4b1ea14e8bf6917688ddfe784c65"
    sha256 cellar: :any_skip_relocation, mojave:        "d8791e24d60ee4bec20125c4fbcc5edbc948b400a93639c15fc4ad6bc75f27c8"
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
