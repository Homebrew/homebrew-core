class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "0af9f1d862cb90554937b36faea6f0014041ba08714a42aeded7fbf687371088"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d4bbedfc7017d23a48e22b8d4a542f0294498b7d7bace26185beb534dfe6d61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64283e8909e7601c39935adcdfb7153491e1800dc647838ca84d1894b5f50994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4b3f605dc08e95b19114d9f111bbd2908430d8cd8664bc68d470c66810924fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83644617a3fb9f2b8271c0f5ee674e4888c152c9ab1f3721686773e9d0c520e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1adabd7e18231886001623ad21b3521d530d55c9dfe86bf12e27a09b88784bcf"
    sha256 cellar: :any_skip_relocation, ventura:       "b87fb874a19a2f62d6f2de1051b9b6836dade1cc9a96f5f017740d92e4490461"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d6a9cdcfa8c236c2cd6dad2e7ae5edd68444738f546641b885801cb23b0b4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99be79b63c1ae045cc5211b72d9c26a2b8c2f6067b334f5d0c67637fe7c12ea6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
