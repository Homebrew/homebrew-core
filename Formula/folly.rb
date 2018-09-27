class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2018.09.24.00.tar.gz"
  sha256 "99b6ddb92ee9cf3db262b372ee7dc6a29fe3e2de14511ecc50458bf77fc29c6e"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "ffe50f82cb7aa49b568f87c872242e876cdda57fb2a27c8830e8f7af82b00d24" => :mojave
    sha256 "cba7593d0a7533dd09a16d1feb693a41837ea9cd58ae05f1b8445139b5ee7bca" => :high_sierra
    sha256 "146006b46b11f6265741822990942072836efd978f44126ba23b7ff21baa6ace" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"

  # https://github.com/facebook/folly/issues/451
  depends_on :macos => :el_capitan

  depends_on "openssl"
  depends_on "snappy"
  depends_on "xz"

  # Known issue upstream. They're working on it:
  # https://github.com/facebook/folly/pull/445
  fails_with :gcc => "6"

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "_build" do
      args = std_cmake_args + %w[
        -DFOLLY_USE_JEMALLOC=OFF
      ]

      # Upstream issue 10 Jun 2018 "Build fails on macOS Sierra"
      # See https://github.com/facebook/folly/issues/864
      args << "-DCOMPILER_HAS_F_ALIGNED_NEW=OFF" if MacOS.version == :sierra

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
    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
