class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  head "https://github.com/facebook/folly.git"

  stable do
    url "https://github.com/facebook/folly/archive/v2017.06.12.00.tar.gz"
    sha256 "6253ad41d42d3fa576e540015ecb481844cd9a954e2f8d4f907a785d8199581f"

    # Fixes build failure reported at https://github.com/facebook/folly/issues/610
    patch do
      url "https://github.com/facebook/folly/commit/972651e.patch"
      sha256 "93162e577dfab17faa487ca990600a46673989131b03e6fda050208abea888da"
    end
  end

  bottle do
    cellar :any
    sha256 "d16c07e009b9109b0dc8225b4a322d7607b53cf4c9324c2819ee4d964836e689" => :sierra
    sha256 "b3b6ad085bbbf1e694a215cd6ac02e3e2dd513b771e77d6e640af1f6147c78b7" => :el_capitan
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
    (testpath/"test.cc").write <<-EOS.undent
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
