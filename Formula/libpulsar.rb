class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.2.0/apache-pulsar-client-cpp-3.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.2.0/apache-pulsar-client-cpp-3.2.0.tar.gz"
  sha256 "e1d007d140906e4e7fc2b47414d551f3c7024bd9d35c8be1bbde3078dc2bddbc"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "08ede2fa1b7e6995c97083b329757c147144b3d46534e174f191a89010048f52"
    sha256 cellar: :any,                 arm64_monterey: "9d2db5a1e841da4ae5556eeca15d813423774970371b23c0430d5b77cb7a55c1"
    sha256 cellar: :any,                 arm64_big_sur:  "1bb7b9ec67b7e26d425f8da1a09eb74efd3054b95a282b375d879d79e3777fdb"
    sha256 cellar: :any,                 ventura:        "6887a1bbc19062cd165ac280ac7347eef293700921a43402b89c36b1dd85b95a"
    sha256 cellar: :any,                 monterey:       "becdc27e25e162aba19399ed54bc335c1a8a54bedd468b4873117d217ffe52d0"
    sha256 cellar: :any,                 big_sur:        "d70e5b0be002d89bce8dedb66669df7a96968dd310a26ea921a0cfcf19326b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dca420007636ef7bf1d9696c1c8ae1ecc994552d52d02b1068f2b9a88402cd5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    # Keep C++ standard in sync with abseil.rb
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD 17"
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                    "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                    "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib/shared_library("libprotobuf")}"
    system "make", "pulsarShared", "pulsarStatic"
    system "make", "install"
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
