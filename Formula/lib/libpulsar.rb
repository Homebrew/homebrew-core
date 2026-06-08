class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.1.0/apache-pulsar-client-cpp-4.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.1.0/apache-pulsar-client-cpp-4.1.0.tar.gz"
  sha256 "e06120720dc40dd9daf05ad9c8aa1b27c1cf28f952a2905fed2641e749f33857"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30baaab116d686cbc70fc952ede49c83f4c91433b2400d558a6086b53d4a6cb5"
    sha256 cellar: :any,                 arm64_sequoia: "0c95c3bf00e842e47713f516417496c1b7695e1fc31d598dfe0111145d8dcd53"
    sha256 cellar: :any,                 arm64_sonoma:  "97712b23ba6ecd25a09785157b946672412e0294cffbf7950df40de5c254e9fa"
    sha256 cellar: :any,                 sonoma:        "73411b383e6dc90361684b03a7dd280915d4e5f51910aeb9e12035572b6bda5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f25503d6cafd7ad11b1991ec2f95b4ce14d0bcf6af61ad247cd7759acc37809e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f1ed5a01a0dc48a9b7558f9b7591e6c59c3bec62e8d94675ceeeccbbd094863"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Fix build for apple, pr ref: https://github.com/apache/pulsar-client-cpp/pull/562
    inreplace "CMakeLists.txt", "-mpclmul", "" if OS.mac? && Hardware::CPU.arm?
    # Fix modern boost signature, pr ref: https://github.com/apache/pulsar-client-cpp/pull/561
    inreplace "lib/AutoClusterFailover.cc", ".cancel(ignored)", ".cancel()"

    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=OFF
    ]
    # Avoid over-linkage to `abseil`.
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:#{free_port}");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
