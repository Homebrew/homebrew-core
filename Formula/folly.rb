class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2020.01.27.00.tar.gz"
  sha256 "ebe3ce81153dbecf2da5750b3e5cf31ab9db7e2581941e0e4eab2cfb12790448"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "2645956407a529951aaf3cfeca3e931c25ffca2ace2975131f5bc50b1b1e2f56" => :catalina
    sha256 "eb423c5a87960a121317eefabda508793bc01ab8da4f22e869504bde069b1785" => :mojave
    sha256 "8954b53e7dd3f79740d621f6901deefb7aba1123c73e71bb3dea831771c83b41" => :high_sierra
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
  depends_on :macos => :high_sierra

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
