class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2018.06.25.00.tar.gz"
  sha256 "ae6d77cb280dae9837cf053771da04384059e8e273914dcf5950c198c1438b23"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "c5ff244dca57f6040284a5d2697f567e5a784a6ea5655b123fc90aee7d7b9c2f" => :high_sierra
    sha256 "de304666bb819ac8a8d846d25f305668106894589464deae95589f6b265f9908" => :sierra
    sha256 "4613ee76c11e5ef6ed13c6c09d49cee4a5620023c0263fe16acc44d97fce84b4" => :el_capitan
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
