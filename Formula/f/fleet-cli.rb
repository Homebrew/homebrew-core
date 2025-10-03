class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "bf745592462dcb5178e95a6d29a6d7842e2361b207e7f324d0e40730c3c1c0ee"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72ea597555050360b2647c45f10cf938f8c5d0a0f09c85b403f1b00b0f5b990e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60a2d3688774e47e179e3f5593dca1cbf37ffa686490aa2d8b306b365d16b8d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b21ae96165ff904a5a883641d5b2886f60a86a08b6a21e018940cbc9f7efe0ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "41d4dfc5af2a4730fd84b522991ddc344eb0a35175d36e33f2e703c27190b5cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78f866fc9adc01a4885b46025120eee0163ed69a3dac3b2567e6cd9cddd49a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a212ea3563a2ec60b274f0c85a3c22467e0c1784530c67167a5fc3438848e6d8"
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
