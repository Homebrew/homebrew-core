class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.2.0/apache-pulsar-client-cpp-3.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.2.0/apache-pulsar-client-cpp-3.2.0.tar.gz"
  sha256 "e1d007d140906e4e7fc2b47414d551f3c7024bd9d35c8be1bbde3078dc2bddbc"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8aed0f192e8caa52051370b0454ce872653a8938241ecb136f700a247aec58df"
    sha256 cellar: :any,                 arm64_monterey: "0ad3463e30162b070506c59bbe0ff288e297f8d89831b0444ff9a8d085adfb76"
    sha256 cellar: :any,                 arm64_big_sur:  "b86c0e9b4c84e559e5182ceb1f720054c9da414532f7a2e0bf0f2fb2fc4938eb"
    sha256 cellar: :any,                 ventura:        "d4038495856d80b0a6b8c86c6412ec8d20d87816b7a74ecaf4acc9b42b81a295"
    sha256 cellar: :any,                 monterey:       "a1f7e567a075f2deee16230a6f18e24c48b0507274971e8ee7c2cc8624048070"
    sha256 cellar: :any,                 big_sur:        "c29ced7b5c01b87521012b160d6e43a289f0c0018800b90e851a7a6abe47f975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84b062d0ad14db67d13baed3724f1908313d06e4ce5b5564d650db2586fe2e3d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    # Needed for `protobuf`, which depends on `abseil`.
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD 17"
    system "cmake", "-S", ".", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON", # protocolbuffers/protobuf#12292
                    "-Dprotobuf_MODULE_COMPATIBLE=ON", # protocolbuffers/protobuf#1931
                    "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                    "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                    "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib/shared_library("libprotobuf")}",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
