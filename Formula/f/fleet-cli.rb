class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "c76516f57151ba59889452fd25e1b5a797ae9c739d120160ec1b7a6c49b58df4"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee1d0a23a24f51a2937cbfb6e53cde83ad7a12fa452e3f3c12a41bb2801ade2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71bcab26cb78c58850afe7d9ee5cb24e61cdafb757b09c0ca4772be428229409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ae91ed0934571ff44b171bb9158957792a3aa457de68f0ab3a97abd5aa4f625"
    sha256 cellar: :any_skip_relocation, sonoma:        "39e6f7aa66ccb779c21f1406ea3abd3889b4df3916c5024578f1986e1ea08414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4229aefe6b042f6a820fadec8692fc32428273add0c1b15d3285619b64a2e391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb38f6d0d826c3cb5475eece1607d79049c5c52401fd3c6dccc432431394ba00"
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
