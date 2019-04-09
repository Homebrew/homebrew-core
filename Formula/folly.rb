class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2019.03.18.00.tar.gz"
  sha256 "45b47d5d0ee5652bcb87bde6b03cf5a3232b04b3750056831b9e72ea4e1871db"
  revision 2
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "34403daae605becd5da491a2354f903498bbc9309e5b7e8847ecc83fe310f9ad" => :mojave
    sha256 "f86f5dffe2a308e6b9ad5a46da71cc5e015fe5eb76fc914ca111c745c7d0908a" => :high_sierra
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
