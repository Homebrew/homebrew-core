class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://fleet.rancher.io/"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "6c72695e11063427a42dc6bebfad4434b509491cc5d316f2053386f6640abf83"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4593d161cc0c230b5e1d0e0086a54ce8464cf9372d573c0077b009d415b778ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21c50f885dc01f1df8f706adbb5b2b395309dd3d780e90739c3561218c271b2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac4afd281b1ce469d89bd618508ce813855d00c12b7d3d838a2f11376f0dc5db"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82d1f4c652e8adca4612e0230e3a4cd44a78c1c4e5bd95769277248690110524"
    sha256 cellar: :any,                 x86_64_linux:      "c65b032184a50ee6652df9dc72312dff3db6b9570610505e7e3605d714eb103d"
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
