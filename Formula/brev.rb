class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.253.tar.gz"
  sha256 "37cd165800438b1ca9605d1241cb8a25a18b5eee3b71b916e38cdd5c87f9f2f6"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c24d8d9cae9abd6a5ca777e7c2cd32a3350d39ef134eccdc46adb19d4b3ae907"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db1ae5f6d90d6b0a04f94c892c95635b08128f39d77cb033a28e800ebc9a862c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ffb7cee55a54a985f957b81187ba080050a58a35d16978bb6bde67671b14529"
    sha256 cellar: :any_skip_relocation, ventura:        "ed22189edd68586c1938b47e9378b0a2af680e215b72222c7dc505c4458bb457"
    sha256 cellar: :any_skip_relocation, monterey:       "57ee52611e77bd280ecb9e93beddf89391e4cf280ddcf14c2d0ef3c60a52e677"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c92a5b656a3ac6a06f35aad623be5d4ffc477c079664f1ec02374a59b773edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9068363443a25267164604ab264b8f341a91073cacc3c460efc26c2b91ef3f37"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
