class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "3231f295cab37d03e5d94d300e73c8eedbf86771ba535290ae0fbc9d56c2d842"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e75cb96dec58220c0dc1b905aa988fcc15898242c481a7fbf864887794b5f718"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68d6d392d1c5befcd2b50990c06760aefefe40720adfe3055206ad4eb23e71cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bf9c069f635d1ecb5cac4b10f9146eda5e005d11ca51f78c1707e667cb58448"
    sha256 cellar: :any_skip_relocation, sonoma:         "3180a6522bfae9ea843f7aec540227f293929c7f09826eafa0569a0646192176"
    sha256 cellar: :any_skip_relocation, ventura:        "402ac66a3e4282ade686ca9d1bc757c75e9d30863ee01de7e92a61683f9390b9"
    sha256 cellar: :any_skip_relocation, monterey:       "166675cf1e59d4dcf59e8f1cb82df2073a78e970b9e31d41b76fcad6b5cdcb97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0adf60d980d6f9120272462f6345e201780bac30ee33eb13575605b0e962a3d2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
