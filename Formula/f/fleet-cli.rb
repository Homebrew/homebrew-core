class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9a10661f73a73bf4e2c12b5852c55074012842bdb6afeb270ebb0ee03b81fbf4"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cf66936612d90eeb69df9750f8ffc92582248bd111b0c8acb10b9dd95229cc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9f8095225cd90ad05de4df8a7ae4a1e0c368084804019c15d472c94adb5908c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f342e542846cb0dae5a3719e0c6bb68a387955c3eb16ae88a1e213c1e5d29bb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5b09346d1086dca67581ff6baaa499a35e3da18619aedce6decdf6f777930ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25df2b827d3fb412b186045d0c9bdfadab6075dba72aaf187f908ae9d68fdcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c0b6d0ca99ac8fb2a59a66c2efcac8fc6ae0701b4fd36ee43c866f6d7a0f34d"
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
