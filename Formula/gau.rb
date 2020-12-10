class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v1.1.0.tar.gz"
  sha256 "1d5cbf2e4a9268268d50eeed3d56608754b6fc0112faa4e26d298f83257f407b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ae2d716079e4c4d418126c7396446aafc714340368b4fb2ebbd29f63cb2ff30" => :big_sur
    sha256 "314c4c8636714511a7d09c14a68bf4e60d5096a3e8121863365f35843891ef57" => :catalina
    sha256 "2ab669a1b9e3321a5c9be26765e62625fb835cf253b7bd3fb702e32036f2c7d8" => :mojave
    sha256 "1030ebef25ac3961a59c9794a16697d894c084d14933e7df7201d4c99313705b" => :high_sierra
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
