class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "https://github.com/ashinn/chibi-scheme"
  url "https://github.com/ashinn/chibi-scheme/archive/0.9.tar.gz"
  sha256 "c61edd9b1891a3248bcd22002a938ccac06d05dbdd879ec34e90fef24451422a"
  license "BSD-3-Clause"
  head "https://github.com/ashinn/chibi-scheme.git"

  bottle do
    sha256 "2e1e4fefe7672d6814cc1902884d817e1d54e9916bff13621fbdb1d36ae05ef2" => :catalina
    sha256 "cffd5499340844f3c4c4c105f66a173ac5cd782ae9266fda32ece1edd07e3f2e" => :mojave
    sha256 "2331acc8a6aedd1ec78aa07e38bfc5f9fc6e97bf41b077c25ccee0a5cb4b3175" => :high_sierra
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
