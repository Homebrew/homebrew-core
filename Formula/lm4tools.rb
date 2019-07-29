class Lm4tools < Formula
  desc "Tools for TI Stellaris Launchpad boards"
  homepage "https://github.com/utzig/lm4tools"
  url "https://github.com/utzig/lm4tools/archive/v0.1.3.tar.gz"
  sha256 "e8064ace3c424b429b7e0b50e58b467d8ed92962b6a6dfa7f6a39942416b1627"

  bottle do
    cellar :any
    sha256 "a0bb88705b97875de770b1979b5480521007b25efd627f092e178941b8ecd4ec" => :mojave
    sha256 "9c65eb6694f74b513b707c237cf13bb6a54b9e4a188582355f78e94f9ac53407" => :high_sierra
    sha256 "3238455d6329e9749700b9c12c2e7459b63ea400fb0e7e6818b8c7c9b77b4e6d" => :sierra
    sha256 "7c6bd7ec1a220de95089d71f79baa61ce459ffa0d00d32af727435594ac7603a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("echo data | #{bin}/lm4flash - 2>&1", 2)
    assert_equal "Unable to find any ICDI devices\n", output
  end
end
