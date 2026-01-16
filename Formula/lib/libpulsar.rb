class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-4.0.0/apache-pulsar-client-cpp-4.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.0.0/apache-pulsar-client-cpp-4.0.0.tar.gz"
  sha256 "8bad1ed09241ba62daa82b84446b3c45e9de5873c407ef09f533fac0332918bc"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96d5610681158549230524ba1260d97d42a6fdcb53c57a4df099042e8dcde209"
    sha256 cellar: :any,                 arm64_sequoia: "0821e2af93ce41f4272547617bc5426c72088724ea05770c5398c53b2e4619d8"
    sha256 cellar: :any,                 arm64_sonoma:  "f7642f3083fff1c256a5edd8bac4861c5b72fb7d8dc915a937a707b2f1f28307"
    sha256 cellar: :any,                 sonoma:        "b911cedad45f4d9ce697f8f0bb90b6b272a18af44f5bf7ebb9f193deff2a135b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1e707047075d08d47af3f37f34bfc081d4920de892bbc83d1a3a4a1701d6067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2b4ba97ed86c3aa59155b7f505d834f3ea4472205580c2f98508d096209a6d8"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
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
