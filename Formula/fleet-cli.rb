class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.10",
      revision: "093cee590dd64451b0de23925ea05a44df866fe2"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efa4426b36fd91d03cb9ced44929cff78094ee1c9a424e4a79710fdb333a9e99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80c192b5bc40a23d40ef51f4bbfcee7a292cbc836c4c5bf5545e3bbe7740de3f"
    sha256 cellar: :any_skip_relocation, monterey:       "c1c75762096b92c8144f64c3dc6783ae1a245792743c08ab91d7c5ff5a8227e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2059cf252073b4301e91ad6b8569c509536336f356857ec9c7ae58b615deaa17"
    sha256 cellar: :any_skip_relocation, catalina:       "c089becae31676292cfe11b954f72cadc282b877ae64de52591ed0b68f664812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a7b4cc2f8d36533465fcd9ed883ca45fde85ded4f2836ab1c7614acbba0677"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags: ldflags)

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
