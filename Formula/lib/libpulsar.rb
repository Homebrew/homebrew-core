class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  sha256 "cc48a168dc44dc2f89122edd692c2919736c794564c8a71c6a7acff86ca2d315"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "085dd8d7e309860bf052473f025f66268a205a85dbdbea31b121b97fe11e819c"
    sha256 cellar: :any, arm64_sequoia: "2e86fa52787be5f214b61fb76db5e8f0fdf7e6c5ed97a87c098bc32e28167aed"
    sha256 cellar: :any, arm64_sonoma:  "651dea4f19eacea1615243561bc94500df5f10ab752ffffafb5af23a77b06d41"
    sha256 cellar: :any, sonoma:        "be26016d037d56d2bf1cbd794f961293d39d12394897b03af969193fa8ba5ffb"
    sha256 cellar: :any, arm64_linux:   "51389768fedb869f6be3fb90ad15849a3d762973101efdb496f0f27668a73fcf"
    sha256 cellar: :any, x86_64_linux:  "7af7575a17dfec39aa6d06dc5620a9b36aef2096ad26c111dfa25a60fa608e9e"
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
