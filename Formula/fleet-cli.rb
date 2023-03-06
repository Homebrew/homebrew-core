class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.5.3",
      revision: "b90a1d37a79da99a273ec67f7127eb657bf5f5ea"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "536c47529ed3533f9741059bb241f566a73223a8c7d775665246cc4df297ec09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85ec60d42f89c82922130e19741c1d4207a12b3be05b7708d28778f2f2c6184c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cab862e4e8eace08ae7514c34f18da50e756f526ee616dd89438c042f1d30dc"
    sha256 cellar: :any_skip_relocation, ventura:        "19f5d98ace208088926050cd090355494939bc63c8fa6dbce4c3d36ca7689291"
    sha256 cellar: :any_skip_relocation, monterey:       "a89e96300504a0b82584018f2332b4f8a9ed1dd257ac23590b2b2f631691cd18"
    sha256 cellar: :any_skip_relocation, big_sur:        "d60a495b13dc41c2a58930d9b1bd761c9040c3049c520db61489ae45ba6cec09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415c14a7129c6aa40f5b7647df57016014c271166c5fada00f243f9a8ad62ab0"
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
