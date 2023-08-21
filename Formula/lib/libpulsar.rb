class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  sha256 "0e04c67d7b644a92081eb6993ebd1579e05080c1fff651728dfa04b054e637bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36a282a02bf966f980f160576ff4bceed163353cc1c4ff34e7c985a9ae4cd0f4"
    sha256 cellar: :any,                 arm64_monterey: "154a8141358d17a3c2431c1ea05f9a245ab6930e30eaec71bca23bccfbcce5b5"
    sha256 cellar: :any,                 arm64_big_sur:  "a77f24f932f8dc95f1adc0a4debed9f91a3e398558dbbf9dd078c5513b3d5ea8"
    sha256 cellar: :any,                 ventura:        "55c6035150bc7901abe2b436b950a78192f9372fd6b74b96bf6c1807e0317e86"
    sha256 cellar: :any,                 monterey:       "449e9b4326376a1fb556c0af84a85c7e5ffad8922f1be5de464b7f4af70416e4"
    sha256 cellar: :any,                 big_sur:        "95265aefbda9f122c64c652666fb0d34ad4d7232ab3078cf44434efc25b41945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a41c13fc8dd0756a4acae5c1b02d57163d69ef32140646f03d26985e0590d62f"
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
