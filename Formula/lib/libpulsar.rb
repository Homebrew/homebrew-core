class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  sha256 "0e04c67d7b644a92081eb6993ebd1579e05080c1fff651728dfa04b054e637bf"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bcc717ebd4ac78c2048ad3743d74db08c5c2b5c797101391755ce51ad607e2ce"
    sha256 cellar: :any,                 arm64_ventura:  "b5c658655fb912566a9da286a9b9f5d04eff7105c0ca8cea9077036ebbf42ed5"
    sha256 cellar: :any,                 arm64_monterey: "7b55fa7fcab05387ad79a638d3370fe5b2f748d83f59cec95d1b2fcb6e3d1e04"
    sha256 cellar: :any,                 arm64_big_sur:  "5a2edfc2213a714627d7d5fd923b1871f682a7897ca09508057158b7c9305194"
    sha256 cellar: :any,                 sonoma:         "15f8ff1f8f480dae89b324f1539e66854112b5384a1dcdc38207a7e5a6ee0283"
    sha256 cellar: :any,                 ventura:        "67e502e57ec30777695069ec7ad2557aa42ff1af2ede7b3bff9f8aa585d41ad2"
    sha256 cellar: :any,                 monterey:       "86431289e53512a56245f5d9537263442be971f43d35213010f8b6cd249caf5e"
    sha256 cellar: :any,                 big_sur:        "4c52c5bbdfeddda7cb92773734bf8369c2b75437158b8e55d3c6442a0e8f1680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70e1d661622c26d295e9cc69232168bbb71ae33e5cd51b04a81d2b071ff30bf3"
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
