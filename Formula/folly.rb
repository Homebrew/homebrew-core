class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.01.25.00.tar.gz"
  sha256 "2ae0d506bcad2815d6689406ad9b2a6c181f23fcde905b06de0568ae5fc03f84"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "5c715302d47061949e32d87d515f0e6c7a72008c8853ec104ddba4bd16908269" => :big_sur
    sha256 "b41de7c1ffd4d2eb30356c47fb35f58d77e7783aa79870d5361552bf5dba6784" => :arm64_big_sur
    sha256 "6e36a38336a11ca98c5ad08a4d4b7deda1352ac60074044c1a7690b32fe6a545" => :catalina
    sha256 "213e784982baae53a3074de42b5be758b90c65b2146b8fa1e5771b63c6778ec6" => :mojave
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
