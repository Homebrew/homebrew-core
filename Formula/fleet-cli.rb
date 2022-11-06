class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.4.0",
      revision: "eae202f68985ce20ff8f97586cd31ee64e7df020"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "422ff0c6cc5ee3706c1a7e775795f7f3029866a524b7c0ce1c7f095409208288"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "383d3705239864c6a387afb4dd45638a99cca00e3be623dccf9f055bcb20001b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39de414fecc3b95f9c8313ca129311a09e7d78da57f73f496f081998b9263d88"
    sha256 cellar: :any_skip_relocation, monterey:       "423a6b8ad7341a562c1ae828abc6c9de0868ee8771946fe373b65189d6b6da45"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8118461bc45bb6e8655e27429003c081506830f44d940e9e699bc35c20fded0"
    sha256 cellar: :any_skip_relocation, catalina:       "8f9e4e44157c69c41f37af09ffae64630b91e14eaecb3e6285bf36aa41b6a977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca892c7f7befbe8fb08d21dc74e523bdc6e8013bb2604e7cda54fbab1b8dc764"
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
