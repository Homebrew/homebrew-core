class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.49.tar.gz"
  sha256 "e8971bc6689ea72b174c194bd43ba2c0b65112b0c3f9fd2371562e0c3ab57d29"

  bottle do
    sha256 "7177b27d32ba728955f8800029827702b17ecb49f5b5cd1435f7c08668fc5353" => :mojave
    sha256 "470a6f3ee6499fcdcb8f80177e60f388e37d3085ff936e09b9ed8a672c048b35" => :high_sierra
    sha256 "45ad0c35749f0d557d7300010901b8babfdc1f5d88bc9f5d9c40a05a31be51b0" => :sierra
    sha256 "a492323f12f328e1854a2a2c406cc0c470d5e61e6e4ea152d6a4b38cc54216ff" => :el_capitan
    sha256 "becae478ba0d094c71ff876db74e9946b51e72df0c6d295e4bfbe0ea337294b0" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match /Ok/, shell_output("#{bin}/ktoblzcheck --outformat=oneline 10000000 123456789", 0)
    assert_match /unknown/, shell_output("#{bin}/ktoblzcheck --outformat=oneline 12345678 100000000", 3)
  end
end
