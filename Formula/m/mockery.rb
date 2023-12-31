class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "d3caea61753f14fe0d990e684a91ba8afa2ab83f250223094ee06192e3ebbb4c"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f3fe0c73af0a2031288e1904e90e5ec359bde844477e3a658fe9b8e141512bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "274cdf916385ecd337ef0a656527aa392a89fbfddca9ee1ec876d00ad3eaf3fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dae216f73d0095615f469eb51d51e33f88cd4da5f40988ae2c544eb85bf44607"
    sha256 cellar: :any_skip_relocation, sonoma:         "7755031ff344481ced3c6c85b680a2acc725be93e1f382dbdfc0a1c2a4c4de3b"
    sha256 cellar: :any_skip_relocation, ventura:        "497c7bdb4b9af0e7bd085ec1bf5a2c1bff2129a044e95c66bcde26cc08c77253"
    sha256 cellar: :any_skip_relocation, monterey:       "f314183ae373c83478958d75d6dc609d19bb11725cd59c884f636d238335cd7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16b62dd0d2a2a58916fc2842ff313bd929f55e7eeb26f5e44de2461d4b2ad2f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
