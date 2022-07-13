class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.10.1/apache-pulsar-2.10.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.10.1/apache-pulsar-2.10.1-src.tar.gz"
  sha256 "a8c8fbea39f1447ebc0c4e899198d0acb48dce05c69ceec78cf8e56856af6946"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "900dd29116523ff79477f4230d8c89089c1e1f531e788a3b07565ba751fabaa8"
    sha256 cellar: :any,                 arm64_big_sur:  "d578f86ad155a95d565f4b90442331cc8ab04f21a685bb21209c0753fc0ebe49"
    sha256 cellar: :any,                 monterey:       "1b29c8b4b53c49af09d43879ce54c8c3fdf5ff7fea377162f08661adb66a8286"
    sha256 cellar: :any,                 big_sur:        "c04815305cfdd16b4aadd5b818adea359600e3ea6823e45dd6ce5346f8232e4f"
    sha256 cellar: :any,                 catalina:       "858c0b60335737d8e21b3e07ca1c2a79f3b9311978d003d79c0bfe199b453194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8108575e9a18d414b8e1679b61e05e95c7cb803a2abc83e8960ada391ada76e5"
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
