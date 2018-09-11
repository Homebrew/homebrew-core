class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2018.09.10.00.tar.gz"
  sha256 "86e58bb2642475abb1fd8608ef0d591892670ac7618b290875a8f48c34625f01"
  revision 1
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "327915f0eb96f02b9245372d6090e40524d5bb391a41a62dea1dc9a3ab9ecc08" => :mojave
    sha256 "df8239b6bbf79792daa0ab78adecc3a2aa1849df2a6f27f7ea86c49ded4585a6" => :high_sierra
    sha256 "a55d9faaed8bd79f7aaabda020a08b3c109519d6de0dd836339b37dae381f6b6" => :sierra
    sha256 "76b87f54dad08694b3eaaf34787111d561adec38e79990b82b9fd8f3d1ae389d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "double-conversion"
  depends_on "glog"
  depends_on "gflags"
  depends_on "boost"
  depends_on "libevent"
  depends_on "xz"
  depends_on "snappy"
  depends_on "lz4"
  depends_on "openssl"

  # https://github.com/facebook/folly/issues/451
  depends_on :macos => :el_capitan

  needs :cxx11

  # Known issue upstream. They're working on it:
  # https://github.com/facebook/folly/pull/445
  fails_with :gcc => "6"

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
