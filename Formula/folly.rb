class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2016.11.28.00.tar.gz"
  sha256 "5a50f75dcf421bf723fbe8d69dc9e3d1bb9935d3b4d5982fc52f29c029ed8c04"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "676698ecb56e087b04f8f9e8d6f2ba243f99d5fa04b4b409595bed3f26167f26" => :sierra
    sha256 "04d2aaaca40c0f1743647d6a5ef7c527419a903f26d4f9c9f969ab59dcfafcf6" => :el_capitan
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
  depends_on "jemalloc"
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
      if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
        # Workaround for "no matching function for call to 'clock_gettime'"
        # See upstream PR from 2 Oct 2016 facebook/folly#488
        inreplace ["Benchmark.cpp", "Benchmark.h"] do |s|
          s.gsub! "clock_gettime(CLOCK_REALTIME",
                  "clock_gettime((clockid_t)CLOCK_REALTIME"
          s.gsub! "clock_getres(CLOCK_REALTIME",
                  "clock_getres((clockid_t)CLOCK_REALTIME", false
        end

        # Fix "candidate function not viable: no known conversion from
        # 'folly::detail::Clock' to 'clockid_t' for 1st argument"
        # See upstream PR mentioned above
        inreplace "portability/Time.h", "typedef uint8_t clockid_t;", ""
      end

      # Build system relies on pkg-config but gflags removed
      # the .pc files so now folly cannot find without flags.
      ENV["GFLAGS_CFLAGS"] = Formula["gflags"].opt_include
      ENV["GFLAGS_LIBS"] = Formula["gflags"].opt_lib

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
