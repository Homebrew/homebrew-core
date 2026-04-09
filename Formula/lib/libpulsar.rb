class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.1.0/apache-pulsar-client-cpp-4.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.1.0/apache-pulsar-client-cpp-4.1.0.tar.gz"
  sha256 "e06120720dc40dd9daf05ad9c8aa1b27c1cf28f952a2905fed2641e749f33857"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "387e10820be107d05aa3f298bcc0256131749798d2ddc7eb36f4954ba4afa3eb"
    sha256 cellar: :any,                 arm64_sequoia: "d9ca742c87d4de90b3e20a2891cf62bdee8cbc73d32b454d079916ae51936d93"
    sha256 cellar: :any,                 arm64_sonoma:  "ac0fa695219bf19abcab796ae5a726b1151cc9b1133ebdcb6981da8528dff6e9"
    sha256 cellar: :any,                 sonoma:        "40886840fb331d76ddb1a2378761dac94ddeb8cd214124ec33ab701feec70eab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "468ecfb427e717c18cf142f9c77d1baa38815e2f183e0ba18b5951d07dd00aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a57367f1e2d370f75789fc01ed31e5c60a888672eee4f09c9b4b451352f991e"
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
    # Fix build for apple, pr ref: https://github.com/apache/pulsar-client-cpp/pull/562
    inreplace "CMakeLists.txt", "-mpclmul", "" if OS.mac? && Hardware::CPU.arm?
    # Fix modern boost signature, pr ref: https://github.com/apache/pulsar-client-cpp/pull/561
    inreplace "lib/AutoClusterFailover.cc", ".cancel(ignored)", ".cancel()"

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
