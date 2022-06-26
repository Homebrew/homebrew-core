class Gif2png < Formula
  desc "Convert GIFs to PNGs"
  homepage "http://www.catb.org/~esr/gif2png/"
  url "http://www.catb.org/~esr/gif2png/gif2png-2.5.13.tar.gz"
  sha256 "997275b20338e6cfe3bd4adb084f82627c34c856bc1d67c915c397cf55146924"

  livecheck do
    url :homepage
    regex(/href=.*?gif2png[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7376913b012f5b2fe0972244be5bbbefc665ed0f13c9d3a8ac2b0fe6d23dd375"
    sha256 cellar: :any,                 arm64_big_sur:  "a8b1dd6b1f3b029b7ca53f99f18caea098810634aea1a745630028e66ecc4203"
    sha256 cellar: :any,                 monterey:       "6f5ad22f5b61cb14009aa71dc7c892093117a1a7d920e9f7712bb27e98e56b4d"
    sha256 cellar: :any,                 big_sur:        "2c3b07aba9f301e689fbc6268894e3ab3a56044741b8b4adabd6afb1d4962af1"
    sha256 cellar: :any,                 catalina:       "cfbf0572aec85f33c51bc58064e20a44de374a319bb369e46c0aab8581756253"
    sha256 cellar: :any,                 mojave:         "95c85cb74a70b1f217c3db5f4f6f6bab2b9871755435a25301bc4215015f1341"
    sha256 cellar: :any,                 high_sierra:    "fd15459a5000f08952b7609ef743d80c84749710e30b7bfbe02d68e7ccc27ed7"
    sha256 cellar: :any,                 sierra:         "25aa7ef95b5ca8e7a79bf884fa8e9c8eafb21f2887caabc3ffb40de5fda2ab26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b0bd58ff5306f1624a6854cf51d42411f489a5223f5c70ae44fb42bd3c7537"
  end

  depends_on "libpng"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    pipe_output "#{bin}/gif2png -O", File.read(test_fixtures("test.gif"))
  end
end
