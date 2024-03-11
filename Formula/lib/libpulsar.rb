class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.4.2/apache-pulsar-client-cpp-3.4.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.4.2/apache-pulsar-client-cpp-3.4.2.tar.gz"
  sha256 "3e9a6f122bb61f9ccb85714b9791b03c68a90bcb9db8ceaac39a44fade000c5c"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d4ac6e4a01530bbc3da4f5e1926e2205b93114d59fdfa70c1b5d8854c70634d"
    sha256 cellar: :any,                 arm64_ventura:  "537025ed64b020af331c9947a5597c5f0946e2793e9c9d7237ec2a71138fe371"
    sha256 cellar: :any,                 arm64_monterey: "850cf0f30e093ef6448cc141a7eb75c9c7df653061b01950da4f3d8c408c454c"
    sha256 cellar: :any,                 sonoma:         "f1d809343998017932b985b6561edb3e94b778e83e4ac28381e8bce40a3b9772"
    sha256 cellar: :any,                 ventura:        "eaabffff5b17b66797608ab52a2ea88dec96e08e42366df282d4e2788a271334"
    sha256 cellar: :any,                 monterey:       "4edf23936f84316c9e857ab4aedacf97e862290d4e29b06fc774909bc4fb7e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "045e2f226d06e3bad9d6124f27f0d348f4a44648de491b3540a0d8217d42883f"
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
