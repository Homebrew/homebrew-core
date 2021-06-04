class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v0.12.3",
      revision: "84388828ae80556f57e11249dbd0063043991fb4",
      shallow:  false
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "024fed12ca3ab93cffda6808e10119299e13a9b8c2ce179a69af2660c4b2a85e"
    sha256 cellar: :any_skip_relocation, big_sur:       "68159b406986696076a65a2867d57fa91af2a9a853ee893cd9958da85d91ca63"
    sha256 cellar: :any_skip_relocation, catalina:      "4157a3eb2ae75658e4ec076b598e77270d9637a577c00ec8ab408c03d3558918"
    sha256 cellar: :any_skip_relocation, mojave:        "1743131428f90ef3bf324532b7d7b1324e4bb92f1f0e5d7e7d1f5082a4680964"
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
