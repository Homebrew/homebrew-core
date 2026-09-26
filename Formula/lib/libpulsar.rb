class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  sha256 "cc48a168dc44dc2f89122edd692c2919736c794564c8a71c6a7acff86ca2d315"
  license "Apache-2.0"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d990aad78a0ff24db3b9dad42464f6fb76a75fda563687b5b57e58046cb4d747"
    sha256 cellar: :any, arm64_tahoe:       "274d981065ad01fd4e432452e3e93dea736fceae4a0b4f848b770c7155274ceb"
    sha256 cellar: :any, arm64_sequoia:     "b804fa4cec59218cc8eb625aa81940b871b1606514491045805d19b9977dfc74"
    sha256 cellar: :any, arm64_linux:       "cf64adba88b2649fe80f3548b7c612051d34e04e80f7b5f8906170fe6dea5e02"
    sha256 cellar: :any, x86_64_linux:      "0107edb0cb8b51348e6edb9f7079427fd203573b5ccfe405841852241b2fb053"
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
