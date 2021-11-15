class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.8.1/apache-pulsar-2.8.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.8.1/apache-pulsar-2.8.1-src.tar.gz"
  sha256 "8e30d0414f840477cad8fc27a09904523f3ff039f7c8570feb6acca047661710"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d66af4667d00250e795e34577700b927b3fbeb73d0ac629d466305333ae2b631"
    sha256 cellar: :any,                 arm64_big_sur:  "f44531771bffaa687d9061132bd83acafd1288cd82b526028366c88ba52a027a"
    sha256 cellar: :any,                 monterey:       "4b8fca76b83c8d16b07c7d7d2cf3585ecc87f6ec3f317e33b9feda96eaed9759"
    sha256 cellar: :any,                 big_sur:        "3dd3fd3c00956ed62b9b2fbb91795889fb06b264e1df331fcb58a445cfa0784d"
    sha256 cellar: :any,                 catalina:       "8538b133cd33c189390d1bcdcaa8d3c41dbac40631697f168f74c415929edf8a"
    sha256 cellar: :any,                 mojave:         "743de257b0996bcf769a74054fcbee90c24a2a3f77584c34960ba3ffdfa153f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8acd3ad68d151b0e698b811d60db8e6eb00d7465c56fe9ac913546c45196dbeb"
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
