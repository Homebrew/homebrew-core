class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.0.1/apache-pulsar-client-cpp-4.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.0.1/apache-pulsar-client-cpp-4.0.1.tar.gz"
  sha256 "4eced48fe96639fb55a69673fb0eb62906d81d9e5dc924a0e7ca8e7c2fb9b978"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79fe4c827b6fb763dba5f1f5bbb329adb00a2449d1ea2cad29e41cfe0978bd47"
    sha256 cellar: :any,                 arm64_sequoia: "dd2dec33e66435cb600fa6fb6234ee6d6d56f8de2647e1578a5fb98900db57df"
    sha256 cellar: :any,                 arm64_sonoma:  "0add7321b4f70d55644851ea940e4e6a08adaa2a6f14b92f25d03bce2379b195"
    sha256 cellar: :any,                 sonoma:        "33b13602d737a393edc1691c9c9f5d43cf008ac96f010021071c933b6f1ce14f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61187641172d5d7f73e3cd35f5f5b0c6e5732daeb2d947a53d5262095337c73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "881923602a4dc184afcdeba7ce4d2e37d2e6cd056ff6e8b68d3a01fc3aad9c16"
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

  # Backport fix for newer Boost
  patch do
    url "https://github.com/apache/pulsar-client-cpp/commit/b3edc60c5ca46c1df7e0090f7e418a684fd21553.patch?full_index=1"
    sha256 "020877581ab90806d05ea2d443ca70e4bab9cebc68a640f8607b442b4ecc95fc"
  end

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
