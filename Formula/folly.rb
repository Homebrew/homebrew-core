class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2019.05.27.00.tar.gz"
  sha256 "7535937e4b4bde14e6c854dc55a5fe9f290ccf1918621f20678ebecd0c1239e1"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "c3e8f8b52cabb5bcc51baf8bc10c87025941c750fefdaaa839749232154a8445" => :mojave
    sha256 "6d70cad03514b2955b5e825e76420504ae9bdabf0c3245bd4dffd86ba8211fa9" => :high_sierra
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

  depends_on "openssl"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  # Known issue upstream. They're working on it:
  # https://github.com/facebook/folly/pull/445
  fails_with :gcc => "6"

  # patch for pclmul compiler flags to fix mojave build
  patch do
    url "https://github.com/facebook/folly/commit/964ca3c4979f72115ebfec58056e968a69d5942c.diff?full_index=1"
    sha256 "b719dd8783f655f0d98cd0e2339ef66753a8d2503c82d334456a86763b0b889f"
  end

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
