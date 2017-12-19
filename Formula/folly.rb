class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2017.12.18.00.tar.gz"
  sha256 "fde0b57cdd40fe57f0c87d315feaa124dd3e86a015a82a682d8834291a98efda"
  revision 1
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "90c179e1c7aae9ff213ccf80cdfd750273c378ffd2e84b275ce1554b2f7d281c" => :high_sierra
    sha256 "9af4d328e423dce34bc5879fcbe97915216333653a114826aa367ae6dc90b020" => :sierra
    sha256 "83c7c5c37a8a5ac1bd82b1e6f176a7bc81fdd4fa23982cfa00671fb8f5dbab59" => :el_capitan
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
