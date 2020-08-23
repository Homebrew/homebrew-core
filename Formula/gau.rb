class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v1.0.3.tar.gz"
  sha256 "fc6e569dace151915474c81285b2ffb03c07968f25d8634a9e6bcaaf9d33d0b4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ffc46be5edcc8803051755209a1071f31dac2a48664f617a1a195c4bf321e70" => :catalina
    sha256 "2d56b62c7697629f246bc71edd4b0d809e8378a31aea8d623f73d2eebd33429c" => :mojave
    sha256 "144d8075a2a90743bf0c52e94582e68b2d6868d4939a9662048e803d32bd173c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/gau -providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
