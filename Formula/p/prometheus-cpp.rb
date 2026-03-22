class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp/releases/download/v1.3.0/prometheus-cpp-with-submodules.tar.gz"
  sha256 "62bc2cc9772db2314dbaae506ae2a75c8ee897dab053d8729e86a637b018fdb6"
  license "MIT"
  revision 1
  head "https://github.com/jupp0r/prometheus-cpp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3660e1736e0bfcfe5209102c6fec8f01868a26c83fee73ae7cac08b29b25bc98"
    sha256 cellar: :any,                 arm64_sequoia: "4bf41e8ce0a562c0a9f078a374826156129b7cb9cddc165ff406df1a95774053"
    sha256 cellar: :any,                 arm64_sonoma:  "4726a53807a467240c83c95f468a2cb62d14fbad87219f4b2620d0af435d2063"
    sha256 cellar: :any,                 tahoe:         "ab1d6c1ba08b580de3b4035564a859080e2b9d04b5a86e1be8ff5926c6bb4b22"
    sha256 cellar: :any,                 sequoia:       "296596fd54a73fb394c0102ba8715704b464c325d1480d8e4425f573fb5aee39"
    sha256 cellar: :any,                 sonoma:        "97f8ef210f77c5f11810e75e48b8a090c3e62f5fb2448b21bcaf4cd8f459a6e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9a5057a04ba0e13c78670a7dd4a9ab09dbfa1d578b835b00a6a3c91fcda5d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "009eb8e6fad556d9d251da2e45bfc897c74518adbb3dbc9b4d6d7f64a9c8ea04"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DENABLE_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <prometheus/registry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end
