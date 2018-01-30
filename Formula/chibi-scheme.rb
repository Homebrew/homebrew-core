class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "http://synthcode.com/wiki/chibi-scheme"
  url "http://synthcode.com/scheme/chibi/chibi-scheme-0.8.0.tgz"
  sha256 "c39287628cb7762d6cd51fbdab39e797ef7f7e576a3c7650a8a2a02b4f35749a"
  head "https://github.com/ashinn/chibi-scheme.git"

  bottle do
    rebuild 2
    sha256 "12a60ba17fa174d9309b5488752073ffc25a0d7c46febf360b674ab6027bd933" => :high_sierra
    sha256 "094b459f06e4ef4a6285e65f79a2e980965010bbc1e26b5e7b02489c04ca43cc" => :sierra
    sha256 "6427ba91b6fd3e63591d9b1f9c4cd173a53dfbef21acfdf1e41612c07ad4a18f" => :el_capitan
    sha256 "a999ce57390290ecc5452be6bda5f6fb415e565b46eb6806650649a85edce99d" => :yosemite
    sha256 "f29383f76167d2998917a0cfe97e362a7780a1e0288fa17d7132099a41291102" => :mavericks
  end

  def install
    ENV.deparallelize

    # "make" and "make install" must be done separately
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = `#{bin}/chibi-scheme -mchibi -e "(for-each write '(0 1 2 3 4 5 6 7 8 9))"`
    assert_equal "0123456789", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
