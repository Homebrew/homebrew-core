class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "https://github.com/ashinn/chibi-scheme"
  url "https://github.com/ashinn/chibi-scheme/archive/0.8.tar.gz"
  sha256 "8a077859b123216c123c243db391b0fe4c0cf73978c7cdd7b8ea853a48192756"
  revision 1
  head "https://github.com/ashinn/chibi-scheme.git"

  bottle do
    sha256 "f282470572fc6498ab24bf3fae1239eb7cc89b424251446dc8bf8063bbd99aea" => :catalina
    sha256 "5cfc8a336bc76a1a268d2af908dd3f78a40cd87aedae92258b1ebb5755409cd9" => :mojave
    sha256 "f5380c4a6d6fb13f6937117da61e71a088897fd53bbbeaa12fdab5cf41bc5540" => :high_sierra
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
