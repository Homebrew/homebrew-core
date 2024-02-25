class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.4.2/apache-pulsar-client-cpp-3.4.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.4.2/apache-pulsar-client-cpp-3.4.2.tar.gz"
  sha256 "3e9a6f122bb61f9ccb85714b9791b03c68a90bcb9db8ceaac39a44fade000c5c"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "65bfe570388aabfc5ffad9ef5ffdf35cba5566556a66c33e436b86701da7e52f"
    sha256 cellar: :any,                 arm64_ventura:  "2dc8daa8d053bfcab5824b4074b5adfd54c6cf92589165a8996f2e1bf60a2f24"
    sha256 cellar: :any,                 arm64_monterey: "927a71cb10df65648bea847d4b77dc2ee5fbeb0b94a5cfff894ea27e7dfc32a8"
    sha256 cellar: :any,                 sonoma:         "466a259434df19781c25677dbcfd716284fb75b5d128126389716a45a4667620"
    sha256 cellar: :any,                 ventura:        "f8ce29fb07b86ba424d981a117262a0f47a3851cf5eb3abce8c754df4eddbc58"
    sha256 cellar: :any,                 monterey:       "2604531dffc25ca138fdba5b874e7f7707f15c5786907e83f0b11b137e78eae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f0ee0355ad533c080b612ac12b6f95bdc9198ff6f3f6f655bfd70714df193d"
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
