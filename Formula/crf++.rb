class Crfxx < Formula
  desc "Conditional random fields for segmenting/labeling sequential data"
  homepage "https://taku910.github.io/crfpp/"
  url "https://ftp.heanet.ie/mirrors/gentoo.org/distfiles/CRF++-0.58.tar.gz"
  mirror "https://drive.google.com/uc?id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ&export=download"
  sha256 "9d1c0a994f25a5025cede5e1d3a687ec98cd4949bfb2aae13f2a873a13259cb2"

  bottle do
    cellar :any
    rebuild 2
    sha256 "19e8421df8bbc57a584452e3d5b895f97a05641b48c7772b0c9810fd2690205c" => :catalina
    sha256 "478347b2973b7ace27af0bc55b3ed3fca14e158433b512a8e92d9cc8f3336872" => :mojave
    sha256 "fa5bcfa302710b90736e3fd21709d4da3619a86251b876d52c9adbb57a3b17f7" => :high_sierra
    sha256 "5c958b605baab60e1b01eb3bbb67851119025c84e1c4c1b2c0a0dd2b272f70ea" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "CXXFLAGS=#{ENV.cflags}", "install"
  end

  test do
    # Using "; true" because crf_test -v and -h exit nonzero under normal operation
    output = shell_output("#{bin}/crf_test --help; true")
    assert_match "CRF++: Yet Another CRF Tool Kit", output
  end
end
