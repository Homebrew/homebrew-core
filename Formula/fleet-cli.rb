class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.7",
      revision: "4aaa778d23dd993f5299e08d144ff0ff81315f7b"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a466212e2bf90ca894173910c5d06fd4c249bddffaeac02ee27acb17ea249e51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf48d0047985e264fda14593511db0f8fae5fda9664decf4a47b497e4eb5111b"
    sha256 cellar: :any_skip_relocation, monterey:       "292c2fe50152feaa574db142be7533632f068c3a1a3db7f2d683ca7e6123b0ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "503a66cb34a145e7c9b36900a00c4d748c344dacfc35745a8ff9d562658b14e1"
    sha256 cellar: :any_skip_relocation, catalina:       "ee29607891b2e044cba27aa79b5730f54f590c2385973f072c242615acc6e3ab"
    sha256 cellar: :any_skip_relocation, mojave:         "ac9243285bad817110379996f22e66ecf37df3cc98f88649bf3e32a3c977801a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d729666f3e185569a384dd3402400d9322a33588d4d62602722e12ab1d28b6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags: ldflags)
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
