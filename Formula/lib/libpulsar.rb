class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  sha256 "d24990757319dfa9c9e5d3263f60105dd9e12ddeaf1396d6b397f87dab2fd7d1"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9a8c4fdce52d8527834802e88e49ef5626be2bcb62874f05054c9c492ce7bfa"
    sha256 cellar: :any,                 arm64_ventura:  "c6de53c50f101028cf3b41acdceab57672b71b5697b76577cc6a1faca1f57d1d"
    sha256 cellar: :any,                 arm64_monterey: "16c747c9d2c151f3d1cc1c41e19177d79015caae94ac41fa5c04a5db2b9c45a7"
    sha256 cellar: :any,                 sonoma:         "80c8ffc6ca9a8c7fee69b6737eb5db3f414eef42de1f373e96eab646ae34fd91"
    sha256 cellar: :any,                 ventura:        "34ed444fa22a3e38f1f69ff2a9a3874d5fa79fd6ff58d6c0a4bf425ee45ca2bd"
    sha256 cellar: :any,                 monterey:       "478b41fda1d301e837e925f5b774b44e30c62683f7f91d9dbd34f985fc9a2353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75319b4881305a725a654a39065bde7023133d3a58211d9c7804dd2af8f8ee30"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
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
