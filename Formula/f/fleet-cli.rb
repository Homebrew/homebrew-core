class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://fleet.rancher.io/"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "68f731ef32ad1ae45a35a4df5b09889c7b14805e60256da4c4eff55c23055c8d"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23fd668b7188215ea78a8b8ceaec1d71a692e6cbc0c39531ec28b377e6a8d916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41f24d528a158d07d51d80c4c1630b803a556a3289141e626bd2e349103c26d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac8a8519eeee1fa087e48c1e3c2f8832c1f698a3a78b8f4556b36c6d59fb00ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "93fc2d5f34e607ab110724bd421700fb457e22dfffc6ca9605fefc5f4f0b43d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d31f9238d60757e0401933053420f3ca8843e00f3e314a0102303429a6aea9f5"
    sha256 cellar: :any,                 x86_64_linux:  "fb1a77d25c41b56db92393e4830c0e2dba9ee85b04d378d776983a45c76a7a1a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", shell_parameter_format: :cobra)
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
