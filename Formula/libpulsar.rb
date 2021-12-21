class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.9.1/apache-pulsar-2.9.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.9.1/apache-pulsar-2.9.1-src.tar.gz"
  sha256 "e219a0b38645c64888ec031516afab0ca3248c194aaaf7bdc1d08aff4537e1f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e295fc24519a70da5840225d1c180cd66b95f31afc276cf6c6dee35a6eb3b470"
    sha256 cellar: :any,                 arm64_big_sur:  "a2f24969d81ac812665dc753de8c6d260ee1f5c2af9d9071e598a2f7236b49a0"
    sha256 cellar: :any,                 monterey:       "b0932dccc80943241142c38e9469aa2c80a6c270f00475f0c17443e134e08aac"
    sha256 cellar: :any,                 big_sur:        "b3523ce63550f6ec38549ba9a05d50339144247c9d53c6c3dd48ac7a92794bc5"
    sha256 cellar: :any,                 catalina:       "38f4cb6e64445494c8eb41f9b86b88eebb70a50df9d76efe2afe50297070d891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d2b81115963ffa50d379ff5af267912910d0fdc781ab1e0b63b88ec66337eb"
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
