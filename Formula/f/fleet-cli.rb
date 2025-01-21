class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "9a04cb2c55dcb92b6e106b93b280306c5fb1822c706251a8adc902a635c4be32"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3303eddc34af622cc034637ee6f74fd526da6c8f1141fd5f6345cd661aab7ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "481c39309005157035346e2a055e6a600fc9b0b0c19746a3b7a6264d2abed7cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daca1a7367664ee09b0faa2e61446535f30e3aba42700a0c873ceab94827db26"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b4e8a2cde47e2ebf1f8d7220af39f7734c0a52a213916b7deb52a1e5e41ca6e"
    sha256 cellar: :any_skip_relocation, ventura:       "e3878296140618866af9bb4e8592cebbab6e84da55d6ff0f82a6716d2fa06cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "027fc6f75560910ac1e1be13436d473a2df18c4732ae8404317984c0a94a40a9"
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
