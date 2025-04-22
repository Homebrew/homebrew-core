class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "0e24c79700a9cb0d9b9a28d01ad19af7858c4d5fa3b01eda14519e60ad1fc3a3"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61a3153c08d49820e403594caa7e1391aa6e5f36255f063ff971eca506b82e3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "120df4fb1d5e2edf98a897a8d7af3b0f364e0f35267fda0fc99a4f990632d7d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7577715ee291dd2edf8f5f0877f182edcfe594c8ed8a6e905f96c4423c6eaff"
    sha256 cellar: :any_skip_relocation, sonoma:        "598597daa23d9a4bd531bd55a9dc3a6cf2eaa2bcdf37a8e1e0ba9a4fdd61fa15"
    sha256 cellar: :any_skip_relocation, ventura:       "344d01d2b8bc58db9a5b936dc6d483277752334f79cce42862d93788c706e9f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a1407a4c4fab2c27447ff923366bb94685ae5b89dda906cde87e72f52c64565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "230aedc5847592b7e29a47a1e65164c4d2de1e994711e634b96492496c0e4745"
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
