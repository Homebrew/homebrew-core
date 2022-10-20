class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v1.0.1",
      revision: "76470b3ec024c8214e1f4253fb1f4c0b28d3df94"
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f5fdbc2b2fc3da800ca8f6cac7c18a1e7d4b7b55318ccecabe68ea5f314a8c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6404e93032552350fb129ad38dbffa03706f78e0bda04402a84449ec5a1439b6"
    sha256 cellar: :any_skip_relocation, monterey:       "d0933848b3a9a8504052b444a83fd1f1a20e0e520d2643584097d1a27377c6d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "755c5a2bd0046088eeb2ca52c8c9b9408ba57a22a4d06d128be59d44e64a5948"
    sha256 cellar: :any_skip_relocation, catalina:       "6b7548ad0125d414b34be316ea7cdc13766457b3bc88c397e36c4dcbb05f6e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9629fedddc178a9429a601d0e91af931aeee3dd9b825f2efb82cbf068967a950"
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end
