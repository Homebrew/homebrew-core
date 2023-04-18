class Cconv < Formula
  desc "Iconv based simplified-traditional Chinese conversion tool"
  homepage "https://github.com/xiaoyjy/cconv"
  url "https://github.com/xiaoyjy/cconv/archive/v0.6.3.tar.gz"
  sha256 "82f46a94829f5a8157d6f686e302ff5710108931973e133d6e19593061b81d84"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "90c54593dd333d215cd536457021fde2a90c768b9d3cbac601be53d4b793f268"
    sha256 cellar: :any,                 arm64_monterey: "26691ab7b01031ee988442fb08c173d48da19e26d9cc494c829284b0248ee6d2"
    sha256 cellar: :any,                 arm64_big_sur:  "58c753e4b4b6887b81202d33c63ac6ef153d7166c6542661ab3dcbb322f173bf"
    sha256 cellar: :any,                 ventura:        "d1848162e06e023be64aa6c61f22e3b2185409e0549c0ae2ad7629590cf10d80"
    sha256 cellar: :any,                 monterey:       "0e2e409ca1a2358465d8a780c94df0041cf7f162139eebdb86e9b6443376fac8"
    sha256 cellar: :any,                 big_sur:        "f39720a1d032edbcdbf6ccfd6a5f8c9dc46faaf95e479904cfde25ec5c7622d6"
    sha256 cellar: :any,                 catalina:       "06b6bafaadcaa16329ba0cdeee7d11a13e94f126a4011b54253e31a1ea82108e"
    sha256 cellar: :any,                 mojave:         "ffaf8b5cab0618e52cfedff14a5084cfe54e0b1b6480433e2ffb4beee8e47ec9"
    sha256 cellar: :any,                 high_sierra:    "c4d197f979340a89d5a87e05eae6a39db38863f89b6ddda42f924472d87a5b0d"
    sha256 cellar: :any,                 sierra:         "2e885b9571a8814f2b23b088f3f0d45f47b1fe762f040c3e66b1a81f84673646"
    sha256 cellar: :any,                 el_capitan:     "bda78602260276dd3e5187a5a9d6bbcfb95ff40aa513840569e490d5dc96aab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7176512194c3bed0f8db76bf768136559dd09bfaaa3562908acaa748ccbd288"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    rm_f include/"unicode.h"
  end

  test do
    encodings = "GB2312, GBK, GB-HANS, GB-HANT, GB18030, BIG5, UTF8, UTF8-CN, UTF8-TW, UTF8-HK"
    assert_match encodings, shell_output("#{bin}/cconv -l")
  end
end
