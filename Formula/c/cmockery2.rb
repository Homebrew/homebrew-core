class Cmockery2 < Formula
  desc "Reviving cmockery unit test framework from Google"
  homepage "https://github.com/lpabon/cmockery2"
  url "https://github.com/lpabon/cmockery2/archive/refs/tags/v1.3.9.tar.gz"
  sha256 "c38054768712351102024afdff037143b4392e1e313bdabb9380cab554f9dbf2"
  license "Apache-2.0"
  head "https://github.com/lpabon/cmockery2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "adb401dab84cc193ef9d46a7d61ad44f333405afcdedf16722d94e23d211bf4c"
    sha256 cellar: :any,                 arm64_sonoma:   "ae822535550629aa3551bb7260330ca338c95c2f3c6b86641362524716aaa320"
    sha256 cellar: :any,                 arm64_ventura:  "9eefe7b0693c469ebd0406452350e1af83f0b343de3d114f0cceadd976e1b549"
    sha256 cellar: :any,                 arm64_monterey: "05efcc1ad197d369912094e402f2ba56c68df59c578c8583b274407e9d35a35d"
    sha256 cellar: :any,                 arm64_big_sur:  "68744e2b1c76021e1ab34568873fcac417629d253cd0213e0040c674aab4928e"
    sha256 cellar: :any,                 sonoma:         "5b98766f552222e7648b31e07c1174a14906743da633235a6ac285f9ad7d99b6"
    sha256 cellar: :any,                 ventura:        "02bafd61618754d288f9acad0b9aeadbaf30c38aa807e7cc1f1362737284c7c8"
    sha256 cellar: :any,                 monterey:       "2f28862d0c9e7a03b64b3222ebdccc3dbf2eae2914dfafcb8862156df0701c30"
    sha256 cellar: :any,                 big_sur:        "9c468c19fff8a8bfaaa8603629b116cf5ec3913e42d126d349c0c8087cd7ee7c"
    sha256 cellar: :any,                 catalina:       "dc794b321aa10ede37917259ba4491dc59271826f2921c5b652b1d67e744b961"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c6ac6d81a0948d2367a87348f13d73d93551be94be3c90040222d0530decce9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3277107c3831686b1fbd803f8d5613f1c29800293c144b982b018f61b63b1870"
  end

  # last commit was 7 years ago, cmockery is also deprecated
  deprecate! date: "2024-07-07", because: :unmaintained
  disable! date: "2025-07-07", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    (share/"example").install "src/example/calculator.c"
  end

  test do
    system ENV.cc, share/"example/calculator.c", "-L#{lib}", "-lcmockery", "-o", "calculator"
    system "./calculator"
  end
end
