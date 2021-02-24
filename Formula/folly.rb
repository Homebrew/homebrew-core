class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.02.22.00.tar.gz"
  sha256 "50857be8d0ab39e2eecef3e14b510f9912e2e501da55b535d7f17b26de211657"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "48edebb074efad18d47bcf56870d0d132fed7ee4b8b5827c21207860cb0ca71f"
    sha256 cellar: :any, big_sur:       "5343dff8c01227ffd3f1cebc96d345457b7e70e4d0b4e67697bc9474543243e9"
    sha256 cellar: :any, catalina:      "7d591f9a7831526787f7ad9bf77eb47970badcefa677c6d400c668bbddb75a04"
    sha256 cellar: :any, mojave:        "551b9de753352206ed30c3495b5b233bded2f1f16d2d19a487645748a8604f58"
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
