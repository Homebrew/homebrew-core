class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "http://synthcode.com/wiki/chibi-scheme"
  url "http://synthcode.com/scheme/chibi/chibi-scheme-0.8.0.tgz"
  sha256 "c39287628cb7762d6cd51fbdab39e797ef7f7e576a3c7650a8a2a02b4f35749a"
  head "https://github.com/ashinn/chibi-scheme.git"

  bottle do
    sha256 "532cd642ab70f1e37ed670206fab9828f0a0b3e93dc20fadb786305f50e80a19" => :high_sierra
    sha256 "c6efeccee97565c675a3f149855dd9550a6f8b7313694b52429e42e4cee9001d" => :sierra
    sha256 "283522e8939e5a2b724b476ce3a1830f4bb48e70b778ffef14030498cd877b16" => :el_capitan
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
