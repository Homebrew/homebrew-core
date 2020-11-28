class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2020.11.23.00.tar.gz"
  sha256 "28940c49c92df15e061e51323be7d1879eaa095f13a715b1e8c0600e4e51bc19"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "68eb6b4c31c0629a237f4a2d420c8759b628271f4f94ce5c84bfbe2a5c3ae6b7" => :big_sur
    sha256 "84481f2e276e3d71801eb421ff38fc5ae97771a0f78a1599ccb518ec249c7c1e" => :catalina
    sha256 "e807f482be6fcac3d5b5f9ee442a63c9df44d884bca10adadedc64b55e69e4e6" => :mojave
    sha256 "4238e809dd169656cbf2909e1a29054300b5a6183d746c9d66d90b3b6a2e7464" => :high_sierra
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
