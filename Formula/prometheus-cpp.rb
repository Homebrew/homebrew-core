class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v1.1.0",
      revision: "c9ffcdda9086ffd9e1283ea7a0276d831f3c8a8d"
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6e257e9946b0cde088a86af5d0a839e2236972c662c2983b813557b7eb02ede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1878e13f58c5fd8a0372e1e3f2716b87fc44b38463c684eca1630c6f6fbdb689"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f0502684fa4c30929c1cfdf07f9aa7e5d4d38b4d0714e01c329115fada715f2"
    sha256 cellar: :any_skip_relocation, ventura:        "1c91c6b106e041efdade1811e5924c883e6c7e69a56008ce50bec35a98f318a5"
    sha256 cellar: :any_skip_relocation, monterey:       "f40470268823a385b19db6ba6341573ad006901f4702f9b6db2fe7165278b497"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d2f91d1402fc65e4a5e0803dbf8c315b6d14db84559a32fe024c741f520e9a6"
    sha256 cellar: :any_skip_relocation, catalina:       "1d472883a72631b29594c8c06b342300c717a6dc36f8dcd5edccdf629e7bdd5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19eec03c31caaf8bc45b222a578b81a90fefe8a7ae5be01a9377d3cb257058c4"
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
