class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v1.0.5.tar.gz"
  sha256 "06571649695da43ef49e19e77df7bf7e9720a942558f7c3b6fe12a62b2d6a2d6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "efb1878aaef1eadaf81da84dd6044f1bba5d5f0eb0ddfdec17fa27886e3dd623" => :catalina
    sha256 "d4657647a6b744e5dfbccde89061a3c9a204917cda75bf6ac95ef4c24950bbbd" => :mojave
    sha256 "bc9e24e07cf5fe77a479e24243c520ac2063d7df95089383a5555b7b468dec5c" => :high_sierra
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
