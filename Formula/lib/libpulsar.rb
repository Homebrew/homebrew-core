class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.5.0/apache-pulsar-client-cpp-3.5.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.5.0/apache-pulsar-client-cpp-3.5.0.tar.gz"
  sha256 "eecd96ef2ef4e24505a06bf84d4b44e76058a5b4c7505539676f96c0fcda44f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4fe19ca52610d7564515bcb170fc9d78903511ace3f653b7f687faafcae0688"
    sha256 cellar: :any,                 arm64_ventura:  "8fed810437524fd8ade271f061ab6e29dc08a8a79dd0b0859ff0493e6f4356f2"
    sha256 cellar: :any,                 arm64_monterey: "1da852edef33a962dd6be3a00cfc792e539d131e3c5fc161cac6d8c9de80f012"
    sha256 cellar: :any,                 sonoma:         "23680520601ffb0ff189f84d78a6627102b5ea6af852638be9c532693c664fa7"
    sha256 cellar: :any,                 ventura:        "e97b76729cf8ea27ee224ddf16db8cd7925b17481eb7d3592dc1d40d58cc2262"
    sha256 cellar: :any,                 monterey:       "80622745e2474ce7b8c82ae215a35203c55f0a3c2620926e006de5dfbd43b75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b2cf8571b66277c71c82e01ea86bfab0f9bf498cd933f22e82321fdd9a04a5"
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
    args = %w[
      -DBUILD_TESTS=OFF
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON # protocolbuffers/protobuf#12292
      -Dprotobuf_MODULE_COMPATIBLE=ON # protocolbuffers/protobuf#1931
      -DCMAKE_CXX_STANDARD=17
    ]

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
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
