class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v2.0.8.tar.gz"
  sha256 "9604f0b7bf258547778a155afd2c58d32eeeb82d3bcbcbe97616ccefd1287d9a"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00a96dbf0cc34dfb56496ae50e010e4aff8198a135d1a0481bc78392ece71ed4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "528f21b04737f159a57832c0d7d925821e6ebfb79c8f5372fdf2221e922be619"
    sha256 cellar: :any_skip_relocation, monterey:       "ff916f02b6af91e0938a114540f05183cad48f903247732d97cf8fd75bd62dcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "de3e307ba6de2d0f18e3f1757d4c7e000eb411e98467e9e6dd0cffc0fd699751"
    sha256 cellar: :any_skip_relocation, catalina:       "35d83e8a497553bc880ec4764174719414997dc3bff2fa9a103ee1fa00739388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "205251b87cb972f5f9125bb158746607e6b118012674892bd70f2050faef3ff3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gau"
  end

  test do
    output = shell_output("#{bin}/gau --providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
