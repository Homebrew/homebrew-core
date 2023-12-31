class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.4.2/apache-pulsar-client-cpp-3.4.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.4.2/apache-pulsar-client-cpp-3.4.2.tar.gz"
  sha256 "3e9a6f122bb61f9ccb85714b9791b03c68a90bcb9db8ceaac39a44fade000c5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "418deebaec39646390fdba49c3259ea430dbfa4bafe01a767ab6cb7611150c3c"
    sha256 cellar: :any,                 arm64_ventura:  "232b74bdddef3e7a7fc0578bcdfef0f7456950dbd6d885fbfe42e71209b3f857"
    sha256 cellar: :any,                 arm64_monterey: "c5a8c43b760cb0743eacc73cfbcebf82138f18d825029bfd91f1c45db61d830e"
    sha256 cellar: :any,                 sonoma:         "140fc5f5b50d515040afbf299a83fd6630ffa99545aff49bc94735a3e8adb5f5"
    sha256 cellar: :any,                 ventura:        "8789c2571f7ed08e13a478095a9ccda00945c894a3469b4e5df33cd36655d6e5"
    sha256 cellar: :any,                 monterey:       "b930bc70b9c086b5ea2568b792006d737ff2052069983bb30bedcfc0bb49dae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dd9679cac90f3400d403dce77b41f463b6d950352f52bad47032288dc873553"
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
