class Cconv < Formula
  desc "Iconv based simplified-traditional Chinese conversion tool"
  homepage "https://github.com/xiaoyjy/cconv"
  url "https://github.com/xiaoyjy/cconv/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "82f46a94829f5a8157d6f686e302ff5710108931973e133d6e19593061b81d84"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bfb30a39eb38f85420bced927f9c1db3d53a584cf4536a474621ad27a4936303"
    sha256 cellar: :any,                 arm64_sequoia:  "09a537e89790d6af0c6c2f1bd9331b1860b86800285c55c5f4420317aeac02ce"
    sha256 cellar: :any,                 arm64_sonoma:   "da6b870d250ca95eff392c8da4c1e703d292a764c02df3b44f3a2ebf1ff06e31"
    sha256 cellar: :any,                 arm64_ventura:  "90c54593dd333d215cd536457021fde2a90c768b9d3cbac601be53d4b793f268"
    sha256 cellar: :any,                 arm64_monterey: "26691ab7b01031ee988442fb08c173d48da19e26d9cc494c829284b0248ee6d2"
    sha256 cellar: :any,                 arm64_big_sur:  "58c753e4b4b6887b81202d33c63ac6ef153d7166c6542661ab3dcbb322f173bf"
    sha256 cellar: :any,                 sonoma:         "ea6d3aef081f06fc31212ce8b68db8ac79eb590f10ab100e0706ecd8e85e5763"
    sha256 cellar: :any,                 ventura:        "d1848162e06e023be64aa6c61f22e3b2185409e0549c0ae2ad7629590cf10d80"
    sha256 cellar: :any,                 monterey:       "0e2e409ca1a2358465d8a780c94df0041cf7f162139eebdb86e9b6443376fac8"
    sha256 cellar: :any,                 big_sur:        "f39720a1d032edbcdbf6ccfd6a5f8c9dc46faaf95e479904cfde25ec5c7622d6"
    sha256 cellar: :any,                 catalina:       "06b6bafaadcaa16329ba0cdeee7d11a13e94f126a4011b54253e31a1ea82108e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bb747250621542e8deeda2696a06b14ce399459ce02ace26986e858446535c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7176512194c3bed0f8db76bf768136559dd09bfaaa3562908acaa748ccbd288"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
    rm(include/"unicode.h")
  end

  test do
    encodings = "GB2312, GBK, GB-HANS, GB-HANT, GB18030, BIG5, UTF8, UTF8-CN, UTF8-TW, UTF8-HK"
    assert_match encodings, shell_output("#{bin}/cconv -l")
  end
end
