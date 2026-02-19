class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-4.0.1/apache-pulsar-client-cpp-4.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.0.1/apache-pulsar-client-cpp-4.0.1.tar.gz"
  sha256 "4eced48fe96639fb55a69673fb0eb62906d81d9e5dc924a0e7ca8e7c2fb9b978"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3e54cb335c9b181a74975e7f24f6ed786731e6518385c92214488f647fee9eb"
    sha256 cellar: :any,                 arm64_sequoia: "754f9a808a4519a308ca1ae6c24cf7cf234bb8c9842e3ae355772a7c7da2444b"
    sha256 cellar: :any,                 arm64_sonoma:  "b6814f439023fa46ffe84e3529f0660021f5cb19fb2ba520316519c8d1ba55e7"
    sha256 cellar: :any,                 sonoma:        "84538528c5c980252c6d285d0411fc7ab6af75d6d022caba4887b0ddb20101da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a848c0d2d3e08dd9c889cf080e7180464624036c8dc35e086166be33093f6dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2902e66a53694ce8a972c7c59927309f8e8c4fd75c04218a067bdd1443702773"
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
