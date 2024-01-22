class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.4.2/apache-pulsar-client-cpp-3.4.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.4.2/apache-pulsar-client-cpp-3.4.2.tar.gz"
  sha256 "3e9a6f122bb61f9ccb85714b9791b03c68a90bcb9db8ceaac39a44fade000c5c"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8060100b91dfbd85b5b1717d99f506518cf3d07131c978835b78cd5c9f3f6fe"
    sha256 cellar: :any,                 arm64_ventura:  "57b79af8a7c6c54c3e69de05e33fdd38bf53655fe3115299ee6078d329f7b431"
    sha256 cellar: :any,                 arm64_monterey: "309588ad02888c021147a65931f2824112c291172fd43b6bd9f8df14380c6969"
    sha256 cellar: :any,                 sonoma:         "45b5d67915edd4d826593820a45212b0f9eb327630f2af6ebede12cc135b738d"
    sha256 cellar: :any,                 ventura:        "cad5e402a815e4ce49cb48d68700e02e5de64defab2911b3e6ee30be30ae140e"
    sha256 cellar: :any,                 monterey:       "dc05c708a4d676a6c8e613b7244b78a81f6a75c06e59655ba1e073d19821f1ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7099ce08bc16b996b3d269c97ba760260c0f69b1be69fdb278b410615fa440d"
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
