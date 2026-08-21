class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  sha256 "cc48a168dc44dc2f89122edd692c2919736c794564c8a71c6a7acff86ca2d315"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d2a221d50e41b2c2517b5eb07c1598c874d9f654fb309dda8071b40a00e258c9"
    sha256 cellar: :any, arm64_sequoia: "f041e80410d9634d884314060d947548cfbb5c226bd99375f94b626a674c4ca5"
    sha256 cellar: :any, arm64_sonoma:  "860f95d57c4b135e35c66a33fd5721ec843ed1564c9920fb38281367f7b79ebd"
    sha256 cellar: :any, sonoma:        "89721f119b48e62c4df3c85949116dc7d72099c8be9fd011aaca7f77a868e7ac"
    sha256 cellar: :any, arm64_linux:   "2fec5d3b8eed60d6962ea7d8aa174cc3362ba89ac4d3c6f43623dc376be4468f"
    sha256 cellar: :any, x86_64_linux:  "1116c60394b60d7c4178b4e86513f119a6370482a4874af52aff48ae90f015e5"
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
