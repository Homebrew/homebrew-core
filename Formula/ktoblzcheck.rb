class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.52.tar.gz"
  sha256 "e433da63af7161a6ce8b1e0c9f0b25bd59ad6d81bc4069e9277c97c1320a3ac4"

  bottle do
    sha256 "b56119ffd81313773bc72fe757bfde4505f2e9e7c16994235e2992390ecb8348" => :catalina
    sha256 "7177b27d32ba728955f8800029827702b17ecb49f5b5cd1435f7c08668fc5353" => :mojave
    sha256 "470a6f3ee6499fcdcb8f80177e60f388e37d3085ff936e09b9ed8a672c048b35" => :high_sierra
    sha256 "45ad0c35749f0d557d7300010901b8babfdc1f5d88bc9f5d9c40a05a31be51b0" => :sierra
    sha256 "a492323f12f328e1854a2a2c406cc0c470d5e61e6e4ea152d6a4b38cc54216ff" => :el_capitan
    sha256 "becae478ba0d094c71ff876db74e9946b51e72df0c6d295e4bfbe0ea337294b0" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match /Ok/, shell_output("#{bin}/ktoblzcheck --outformat=oneline 10000000 123456789")
    assert_match /unknown/, shell_output("#{bin}/ktoblzcheck --outformat=oneline 12345678 100000000", 3)
  end
end
