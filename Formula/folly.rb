class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2019.10.07.00.tar.gz"
  sha256 "3c8ab22e551ff73509aa008454d5e15da9a05b64bc20450459c3da2471729fff"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "964767e7816b4c7ea0577773e589770d077468294a5fb8983b549dc702b7d6b5" => :catalina
    sha256 "2f978dd2c076ce81e22b449687ed5b980938eed302c04275c85253b123ec4f22" => :mojave
    sha256 "f2c54447d9dae0c25f24076beac8ddf2d9005d9e595f3d7b3bb3946bc60233a2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
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
