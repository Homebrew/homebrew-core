class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "69c44e13ebd5f583412272430796dec5c4e570ca0de34fbe7ba34486f3117bbb"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd55b01c5ef2d31e3d0bc021b5667da23caf1b3e9acb9cbbcdcec2236eebca50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dcbc94e73d9fee7a2dd3307bab8846e00c257addd7c506e282bc879fb0ebfbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4c1d52ec2377e07bfd862563b00eecd31f68859f7776cdf580e8b1c82e73ed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1f7e9c2a7dc02ad67d7d9422668fe45812bfa988eea98b4a0032a256451f7f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23d24d01be29c589f60777711b2137e15f232c7d329ba391c79cf56dd5df1c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be2c7b25d56b922aa216536525e149644729ff2a3bf6599963ad6b6a697cd52a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
