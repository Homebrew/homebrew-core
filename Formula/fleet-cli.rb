class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.5",
      revision: "f414eab0e4de0523eca797fa7bf47fccb1997e4a"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "787b39973c33b6f384daf4200565a9987a1de43a4fdea793635f508831cd45ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "774825e3423df7d450093e89b28dad316e771ff70ef9bd9700c6487b9203a61e"
    sha256 cellar: :any_skip_relocation, catalina:      "ba819e91743e38546b7c84eb0f4fb0a2bc74fd69bdff76e1b86987d7f2d8cd7b"
    sha256 cellar: :any_skip_relocation, mojave:        "92879bfb176b7f43706852ac3ecb665158e70a777e1d6c143758f507201ccdb9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "-o", bin/"fleet"
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
