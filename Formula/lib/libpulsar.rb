class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.3.0/apache-pulsar-client-cpp-3.3.0.tar.gz"
  sha256 "0e04c67d7b644a92081eb6993ebd1579e05080c1fff651728dfa04b054e637bf"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eca9abf8f1f9dacf8bd3ebe5135997e2b0d2e2c998f56ccf82b527fd86705698"
    sha256 cellar: :any,                 arm64_ventura:  "b309dfaffb58e96c375eae76b33c43cba6b922fb5bc879e7400214d9b9d27bea"
    sha256 cellar: :any,                 arm64_monterey: "b9153a5816495631235e2f86e569a42a2414c7645dd5611721d3b3b4637c57e0"
    sha256 cellar: :any,                 sonoma:         "54d52cfbaf011c667407330cef24d11e85cfa8a8ffcddd3383c35a3c43a0013f"
    sha256 cellar: :any,                 ventura:        "6c6c96a3c5bac627fcfe9ea4ce135604fca70dccacea02925c09f213ef67f9c6"
    sha256 cellar: :any,                 monterey:       "4c6ca11b31c9e16248a1c19ad23f29d61cd42e06b22163412f861df0cb4bb215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "924da9692ebd279445d759732952c6695a60788e9b71ba3dacc082a46046b277"
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
