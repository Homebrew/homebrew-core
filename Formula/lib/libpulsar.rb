class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  sha256 "cc48a168dc44dc2f89122edd692c2919736c794564c8a71c6a7acff86ca2d315"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "56e8b731e0e47ed8e83525da0ee6b2aeade1d9100e5795ba2320b47a8f10df1d"
    sha256 cellar: :any, arm64_sequoia: "5c376c4585c70a28641d0c69ef04af16d99c1f3641c61166c030f452dc95d708"
    sha256 cellar: :any, arm64_sonoma:  "43be9beba30dd8e0cf02628be400c332d5ce0b6741322d757d0c1b3b982c6acc"
    sha256 cellar: :any, arm64_linux:   "f5d215b744e9b56cea0aa36ed7d373a87d6054da78bf25f646aaa42bbc5a4091"
    sha256 cellar: :any, x86_64_linux:  "5ada6d94b2adcca97d988561c991fc5b962cca7a7c8ab3851cee3852c0465675"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}
      -DUSE_ASIO=OFF
    ]
    # Avoid over-linkage to `abseil`.
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:#{free_port}");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
