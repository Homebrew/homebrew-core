class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.1.2/apache-pulsar-client-cpp-3.1.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.1.2/apache-pulsar-client-cpp-3.1.2.tar.gz"
  sha256 "371a34a61930374bd8a1e503ef556e740354e7ccb59ef2a4fe8e499fa4974423"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "47b470f8834aa3990d87a2be3d5031a9386be0a7f54477ce785d56d61a1b78e8"
    sha256 cellar: :any,                 arm64_monterey: "d16d06e6f95aeb60fcfbf14f231f8a072d908bda712a78030980b268563421c1"
    sha256 cellar: :any,                 arm64_big_sur:  "39d4e970c2e24edd4a41e65049cd3601760ef346a9fdfb01c2822d77af8bfb67"
    sha256 cellar: :any,                 ventura:        "23c5f9e97bc8a134e3b1837e63686000c23f4d8bd302fda88427674a6b37ecd8"
    sha256 cellar: :any,                 monterey:       "ca359381c64131beaab1c269acbcf9297475c9f2bc44e37d06e7c8e272655071"
    sha256 cellar: :any,                 big_sur:        "3526ed25a3cb325c1068939152084aed9a1d205793e95b6157c95977fcbd09de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e2db0946a4737db940b101b606468fe03110dcc3f622f3bfd0e0d440bcd612"
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
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_TESTS=OFF",
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
