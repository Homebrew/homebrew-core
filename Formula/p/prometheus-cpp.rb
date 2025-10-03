class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp/releases/download/v1.3.0/prometheus-cpp-with-submodules.tar.gz"
  sha256 "62bc2cc9772db2314dbaae506ae2a75c8ee897dab053d8729e86a637b018fdb6"
  license "MIT"
  revision 1
  head "https://github.com/jupp0r/prometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a31529be0b28fd1105ef7303ea057fd2da2bf90952b90147181fc36ec9f274d2"
    sha256 cellar: :any,                 arm64_sequoia: "67fe748cad481abce5867c7402ea31ad4deaee191260205d8800abf5a892c3d4"
    sha256 cellar: :any,                 arm64_sonoma:  "ab7bf9c8c6814af4fe56d2a669a602dbf2f3a802685527308c1d03d19772fd58"
    sha256 cellar: :any,                 arm64_ventura: "a57c78acfdc6c2da03a6a86bfc67a198d171d0c6769cb4435efd51c07e36d8aa"
    sha256 cellar: :any,                 sonoma:        "e8ee4564c89feef24f7abf08bd218dc6b69de9f40ebc69fc178f67661bc40c99"
    sha256 cellar: :any,                 ventura:       "8d82c34b65dbc59e5b0817bc4cbe22745e2ba39eef9b2579b39cb31f55b51f9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4093c9bee3ed15272957c3254c042fe99bbb85e8d8dfe0614a072c46d36f7525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ed60a657d6508498016fb99c917682d5c5cf7c3931eb042d6cb3a248ed6d51b"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
