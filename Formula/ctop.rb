class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
    tag:      "v0.7.4",
    revision: "426dd2c9854786bdfba7a55272256502849ccfb5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6e714eb31bdaba6389494a4df3fb88f44a0c549f35ab91db4084a2be425c988" => :catalina
    sha256 "6f770da2bb6f915aa4a39d6cd0788f601c86a693eafe37071da7e13fa9d3910b" => :mojave
    sha256 "6fb6e94dd381f3313d964b81a3490c3025fb9e654945a22c5cb5c7705b8a5bf8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ctop"
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
