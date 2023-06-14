class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.7.0",
      revision: "414e4337dcb3bd10ede130f40f38ddeccc3fcd90"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "287bee28b07d9faf99a1a8caca5b86e9069aebe27baf7e9579093650643c5c76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec06b97e9e1017ece42b693f02098246da69081497dd824d6015cb21997eec18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d10108005b5528bfa11ffd478b3c0fdce5ec2dc685c243d84415a3ad50ea65a3"
    sha256 cellar: :any_skip_relocation, ventura:        "b99ed69c3de4801db0a5fc08e0dd18aa9a91b1a288ab641ef0dacd70e5149338"
    sha256 cellar: :any_skip_relocation, monterey:       "90f8befbfdee6becc920cab2a7027bf3933e53c8ae36d0b6262376fbdcf5f774"
    sha256 cellar: :any_skip_relocation, big_sur:        "73952254545d46979d6900d3e77df15b51de34c444f038b39f933113c6b692a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d69b86a0fe2641d6ec3c77313e3d684b383dc6a26c1323183c198678bc35f55"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags: ldflags)

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
