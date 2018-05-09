class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2018.05.07.00.tar.gz"
  sha256 "d3d5b653070bd21e8b1f0bfc26a28bb0948fd6d81a5db67bed60659e9dabb547"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "a0763bdb46878f3ca9559a4b5045abee55f4f30d9541eecfcf84e9718272765d" => :high_sierra
    sha256 "764986fbe3dba7bd50f384bd7468e1048ef37ab25427dab96a3c622cfa967fba" => :sierra
    sha256 "a7d1717d60a9657c5d2d2fe7fab834a8d1458cf0d8109fd636dbe5e386d67107" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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

  # Remove for > 2018.05.07.00
  # Fix build failure "error: no matching function for call to 'min'"
  # Upstream commit from 7 May 2018 "Use size_t for
  # ThreadPoolExecutor::getPendingTaskCountImpl"
  patch do
    url "https://github.com/facebook/folly/commit/a463b55ed3.patch?full_index=1"
    sha256 "b72c88b081f204caddfd4fd2e7b49f43bbad7cc15f6214793993204ddafd405d"
  end

  # Remove for > 2018.05.07.00
  # Fixes an issue with the first patch above
  # Upstream commit from 8 May 2018 "Fix ThreadPoolExecutor::getPendingTaskCount decl"
  patch do
    url "https://github.com/facebook/folly/commit/bf237b575e.patch?full_index=1"
    sha256 "2216295c4155b64e3d6130e049fac77c1ecf4b10209dfb688285d4d4c17bd3dc"
  end

  def install
    ENV.cxx11

    cd "folly" do
      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                            "--disable-dependency-tracking"
      system "make"
      system "make", "install"
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
