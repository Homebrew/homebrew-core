class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v0.11.0",
      revision: "bb017ec15a824d3301845a1274b4b46a01d6d871",
      shallow:  false
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3881dde4616cd5c5f840b25e5b99f1350f4105fe685c068eb91c582f9eb816b" => :big_sur
    sha256 "d60d427eb5c81eb3816253c30bdb81ec20abf8ae839f001a77340a92b2f5f740" => :arm64_big_sur
    sha256 "bb1e958b203392f2af6de4a5897473ecb4e46bf9125a7317e6987abdd1b2dbf3" => :catalina
    sha256 "cd9c05bd7cdce396324d8390cbf1ada2d34afc3f7d97189f75e4ad530a005342" => :mojave
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
