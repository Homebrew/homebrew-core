class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v0.57.0.tar.gz"
  sha256 "92fc421e5ea4283e3c515d6062cb1b7ef21965621544f4f85a2251455e034e4b"
  revision 1

  bottle do
    cellar :any
    sha256 "8a94470124a2cd93b775e233f3d75ac9b03e0dd4a9ba5da2ddf25901f94b1456" => :el_capitan
    sha256 "00b1bb3943041c7f43fc4f45bc427825966988116be0d8bb9e4f60e361480348" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "double-conversion"
  depends_on "glog"
  depends_on "gflags"
  depends_on "boost"
  depends_on "libevent"
  depends_on "xz"
  depends_on "snappy"
  depends_on "lz4"
  depends_on "jemalloc"
  depends_on "openssl"

  needs :cxx11
  depends_on :macos => :mavericks

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  fails_with :gcc => "5"

  patch do
    url "https://github.com/facebook/folly/commit/f0fdd87aa9b1074b41bbaa3257fb398deacc6e16.patch"
    sha256 "2321118a14e642424822245f67dc644a208adb711e2c085adef0fc5ff8da20d3"
  end

  patch do
    url "https://github.com/facebook/folly/commit/29193aca605bb93d82a3c92acd95bb342115f3a4.patch"
    sha256 "e74f04f09a2bb891567796093ca2ce87b69ea838bb19aadc0b5c241ab6e768eb"
  end

  def install
    ENV.cxx11
    cd "folly" do
      system "autoreconf", "-i"
      system "./configure", "--prefix=#{prefix}"
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
    system ENV.cxx, "-std=c++11", "test.cc", "-L#{lib}", "-lfolly", "-o", "test"
    system "./test"
  end
end
