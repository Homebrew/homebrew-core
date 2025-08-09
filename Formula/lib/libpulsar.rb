class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  sha256 "e4eee34cfa3d5838c08f20ac70f5b28239cb137bb59c75199f809141070620dd"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7470a072222eab22c316fb2ecefd7476f14e97a7bb6e600b59f79d12da7d7a0f"
    sha256 cellar: :any,                 arm64_sonoma:  "e32fe7d97dfea8cfa54b84d463a577342653b20db28b60d28626cd76f4c92491"
    sha256 cellar: :any,                 arm64_ventura: "ea64a5256f5120a830ed6179a7971037f51e7c8efa03cea0d6ecd38f560477cb"
    sha256 cellar: :any,                 sonoma:        "a022dd229f164f1494bed226e95955b0362c1e175346084eb4810c10167b85f7"
    sha256 cellar: :any,                 ventura:       "07fd5eac1bf134adf5fb49108bb6223919f022dc05a4ced8c504d35a65a2ee1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a01dd49404957743f1094f2eda723b758912bd379a2377022e35f121a952ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccd0e28b6282ca3545ec237d3bbb7078eec863ce1a798ddacbe3a72c5d5de74b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "abseil"
  depends_on "openssl@3"
  depends_on "protobuf@29"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Backport of https://github.com/apache/pulsar-client-cpp/pull/477
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/93a4bb54004417c3742ca0e41183c662d9f417f5/libpulsar/asio.patch"
    sha256 "519ecb20d3721575a916f45e7e0d382ae61de38ceaee23b53b97c7b4fcdbc019"
  end

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=OFF
    ]

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

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
