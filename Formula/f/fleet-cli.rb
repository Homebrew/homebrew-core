class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.9.2",
      revision: "e75c1fb498e3137ba39c2bdc4d59c9122f5ef9c6"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e0d5316a421a38ffc208678ad8935dd446f9c35b3b6390d641ba122a04be27c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c950c89ecad402a08f6a5b852faca597db60c2379574480159f3a769d2c35bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59dd72e3601c24f3a6ba3bacb615c82a127d9e967492843b6ce2ebb4a7385b2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a88e55ddb315779760e74387320f61e95d0d12b1c242e845d5bed5ffb0627158"
    sha256 cellar: :any_skip_relocation, ventura:        "e2f4fa81a2b323548258c627df8040095369adaaa7d5bc669b9af94b940db8c1"
    sha256 cellar: :any_skip_relocation, monterey:       "b3fb1c935e14a76cef36c9744bd0cb53d09c33eb0e1b8e192a1a04dc3747744b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceab17c027c00d9c8f3a01c6256de99217d1746b1778642c37687b416ac04c56"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
