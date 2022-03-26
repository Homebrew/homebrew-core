class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.9.2/apache-pulsar-2.9.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.9.2/apache-pulsar-2.9.2-src.tar.gz"
  sha256 "66cf22136488aabe443d92284fbb3edb15e1b9d8a64cf498b36236f75af29bbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2c790f4f6d48393ee7412f46fd5aeb5ad5cf1499e6e1238304331d7d4f0e61ee"
    sha256 cellar: :any,                 arm64_big_sur:  "240ff43c945d8924f2c70f431394b3b67d5cfcdc471943107e903d5ca3a5c899"
    sha256 cellar: :any,                 monterey:       "36da8308922c41cc7fe68b3264e3bcca2f57fa24e2512710ae0d4ce523bd2612"
    sha256 cellar: :any,                 big_sur:        "2b938019bc7c4aefb3303fcce3778db1f258ec788175a435a8c4c3d402660abd"
    sha256 cellar: :any,                 catalina:       "ca5067a26b804426502b36d1fed0426775822d1ba4cea2bf737579838b889fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa623560cf7af0b68e32a3ab29047b4db23255a00119c72b87cfa27c05407c4b"
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
