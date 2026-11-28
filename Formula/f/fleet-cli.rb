class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://fleet.rancher.io/"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "584631ac15d92f89f4791bbd47306a16812e89ae6901b069a6a0a1151812931a"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "14d74488db3a13f756a7cd8ad22e240f1a536eca235b558e4b29a60b03c33ff3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "596bb89998a7b4b771000307f318231a4cec5fa7fe942ab58f429500b776e842"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "445d957139d074154dc287dd934a4bb6e85976851fd2619896293ccca10c9fa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13f62e0b994f91e9b32da871d1404dd673f1e43de29e6b84c3a6e18bd5640ba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f31d8eb36a0e25a33a5c787dadd50e06c3f3987e9f1e15f9a247d60065834fd"
    sha256 cellar: :any,                 x86_64_linux:      "f22ac48defda311035a6bbdc3d5e0f8a22689fd61cb45498d00ff2f9e270aa97"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
