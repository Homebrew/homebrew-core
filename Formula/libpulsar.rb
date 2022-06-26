class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.10.0/apache-pulsar-2.10.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.10.0/apache-pulsar-2.10.0-src.tar.gz"
  sha256 "fadf27077c5a15852791bea45f34191de1edc25799ecd6e2730a9ff656789c0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6c9795af3ec11eb32a9dbbda83f4113e72b9ad62cbcfeb68f545c474510d4bc4"
    sha256 cellar: :any,                 arm64_big_sur:  "8ab2a832705b99e2dad9ce0fd87dfd1c00de4a5d3d06c3178483a337cb158e2f"
    sha256 cellar: :any,                 monterey:       "922a8469c0d5584977189d29d28fc54183717ea898567dcb87bad874926d574f"
    sha256 cellar: :any,                 big_sur:        "ecf7dfe6ceba21fe9eec2f8164f1d9fc86e06706ac97b50560fe746812cfbe76"
    sha256 cellar: :any,                 catalina:       "deead4eef767365ac630a35ac3cd82862d0daec4898688f2f4a147342d78614b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c93623b4e205c722de6b7c73c01a11fb0b02fe5b9321aae9f4d7c511f4f9fca5"
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
    cd "pulsar-client-cpp" do
      system "cmake", ".", *std_cmake_args,
                      "-DBUILD_TESTS=OFF",
                      "-DBUILD_PYTHON_WRAPPER=OFF",
                      "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                      "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                      "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib}/libprotobuf.dylib"
      system "make", "pulsarShared", "pulsarStatic"
      system "make", "install"
    end
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
