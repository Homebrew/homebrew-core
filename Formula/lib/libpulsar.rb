class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.0.1/apache-pulsar-client-cpp-4.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.0.1/apache-pulsar-client-cpp-4.0.1.tar.gz"
  sha256 "4eced48fe96639fb55a69673fb0eb62906d81d9e5dc924a0e7ca8e7c2fb9b978"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32dbd4c43373c832d158fea243f0ee4603d7a428d6e013a7365111eb1151eb69"
    sha256 cellar: :any,                 arm64_sequoia: "87c1fc865b4350a7ecf222ad538634c99d2bc715da69b60fa7b7fd47116a6b97"
    sha256 cellar: :any,                 arm64_sonoma:  "53d9b865b2a00f7d377748d01bc84d60cda7c70ebd4e78d416d235c30f606a49"
    sha256 cellar: :any,                 sonoma:        "8ffc8ae6d65237d3a0c084514adf48083f4f30b17c4ad5d633759d6446156ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae8079dc7f3856d8f77fd2ed97ba3f33706bb1271812813c58f88ea9562a3764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc669ecb9499a8885cfb716eef4686bf5f3d34e90390cb0a4e285414a1de03c1"
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
