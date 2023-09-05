class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  sha256 "0e04c67d7b644a92081eb6993ebd1579e05080c1fff651728dfa04b054e637bf"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "577270cfd9419c22f46a1d4a5c2c66f8839fda4a611a13a9b9ba40925cb0f889"
    sha256 cellar: :any,                 arm64_monterey: "21effef7e413a77f98126cbc3a9affb3a5729fb6ff86f9125e9b71c940f9fd87"
    sha256 cellar: :any,                 arm64_big_sur:  "c610f2e84d03b114422e9b1d25b434915db177dc973f881de1a03a04b4f3988c"
    sha256 cellar: :any,                 ventura:        "537947ce56309ecddd6c4df41243a35a3b05258b9a55da288f07865ddb2d166e"
    sha256 cellar: :any,                 monterey:       "d5323ef54c073eadaef89cec5e88b1561857ca036d03ff3dc40427fb6a6567da"
    sha256 cellar: :any,                 big_sur:        "757d6b4636ea1184aaa228b4f0ca0c5c2ce096bc4aaffeb5a7a0e8e954aa5e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcf18e12077fc87134bba6f6eebd3ebd3de67c558043acbadb1c5b14926d6677"
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
