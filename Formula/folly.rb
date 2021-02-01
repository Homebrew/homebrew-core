class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.02.01.00.tar.gz"
  sha256 "4b05328957e8cbf6bc4b676d0e69514492d75807075162351202d577f641880f"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "6a75ff2128c747faaa50a794cd32f78b5ceeae2039c34d7f8badb62edc2ad2aa" => :big_sur
    sha256 "c154cac90cc26034777547fd7bf96085b62e4ca34db107ccc2a556970b5e77f2" => :arm64_big_sur
    sha256 "f64ca31d7bd363bfcf09bc032b16cb29bd4085889e37c9e666276735f0a03e81" => :catalina
    sha256 "31aaae934650cd865092f599155423a2ae32373c286d70ef7437e6db6a0b93f1" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  # https://github.com/facebook/folly/issues/966
  depends_on macos: :high_sierra
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  def install
    mkdir "_build" do
      args = std_cmake_args + %w[
        -DFOLLY_USE_JEMALLOC=OFF
      ]

      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"

      system "make", "clean"
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libfolly.a", "folly/libfollybenchmark.a"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
