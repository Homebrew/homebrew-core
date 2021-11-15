class Cmockery2 < Formula
  desc "Reviving cmockery unit test framework from Google"
  homepage "https://github.com/lpabon/cmockery2"
  url "https://github.com/lpabon/cmockery2/archive/v1.3.9.tar.gz"
  sha256 "c38054768712351102024afdff037143b4392e1e313bdabb9380cab554f9dbf2"
  license "Apache-2.0"
  head "https://github.com/lpabon/cmockery2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "68744e2b1c76021e1ab34568873fcac417629d253cd0213e0040c674aab4928e"
    sha256 cellar: :any,                 big_sur:       "9c468c19fff8a8bfaaa8603629b116cf5ec3913e42d126d349c0c8087cd7ee7c"
    sha256 cellar: :any,                 catalina:      "dc794b321aa10ede37917259ba4491dc59271826f2921c5b652b1d67e744b961"
    sha256 cellar: :any,                 mojave:        "a36cbb449fcca235226fcfa94439f2370f22d3d6f1986c710c1e640959f8a271"
    sha256 cellar: :any,                 high_sierra:   "3651caa0ed8c5e2ec5dc0fe8932a53e20c2af28d3887161d1cdfe9c46fb9f220"
    sha256 cellar: :any,                 sierra:        "661b4a8751a4dbe7e52b19cd9452d8b7dd61c929d73da27ac4fca5623a0dff6c"
    sha256 cellar: :any,                 el_capitan:    "61b64aeaf89d205742bbb254148502cd2df83bcf05d20377bdce8637f275bee5"
    sha256 cellar: :any,                 yosemite:      "ea94ba8420bd5bc01412b52ce9c03b392b933f279d1bce7a8ff8f7502bc83f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3277107c3831686b1fbd803f8d5613f1c29800293c144b982b018f61b63b1870"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    (share+"example").install "src/example/calculator.c"
  end

  test do
    system ENV.cc, share+"example/calculator.c", "-L#{lib}", "-lcmockery", "-o", "calculator"
    system "./calculator"
  end
end
