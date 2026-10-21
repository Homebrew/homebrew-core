class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  sha256 "cc48a168dc44dc2f89122edd692c2919736c794564c8a71c6a7acff86ca2d315"
  license "Apache-2.0"
  revision 6

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bbf80de57dcad2c7bb1da98e913e36b4e70a0a51ced6afb93567f984a65cd5e4"
    sha256 cellar: :any, arm64_tahoe:       "a5c787e3d881e732744fe067657a554979668fa08c430c647b66222463e3f37e"
    sha256 cellar: :any, arm64_sequoia:     "e32066daf506bcce8cde469159885a2d531fcbe14ce16a6d2446727cf939ff75"
    sha256 cellar: :any, arm64_linux:       "44f61f92597fb8b4f702a453a469120ae70b82402d5f63b4da9b464ebb3a6f1c"
    sha256 cellar: :any, x86_64_linux:      "2132023b616d4037fcda21bd8fd5e0e8cd410359e46a73958ae7b03a8bb7507d"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@4"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}
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
