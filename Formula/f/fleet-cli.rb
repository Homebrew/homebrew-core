class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://fleet.rancher.io/"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "0bcb0378fb336d6c38af3f13fb28104a3c2e340e1efa92db953a5bbbe25d575b"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e41d9a83be3496904334b8fa80c5e2c9bb9a99752b04e9bb7b39ce578e158c50"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "923e994974dbef00ff0dcc723fa63f778f454e34a4479e159c645f9c574b7788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30cbdfca2eb64bbe700d6b7ce05b7e8db22935f90fa41b6083c584f7e3b1b24c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d2fb2a22a65d82031349021c5ab4f64caa2351bb9ae2908e11e25d4c01a2a30"
    sha256 cellar: :any,                 x86_64_linux:      "706bb078fedd86d8d1cc1534c7986f438a00ee91642bc4d38f629cff22b1f0d5"
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
