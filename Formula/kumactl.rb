class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.4.1.tar.gz"
  sha256 "84561a735325128d3b083ee9032a2f5c55d54d24ef43af354ac690a5bf3de773"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b91dbd3a57d62686022e9ddb34c6b7e2ec91168e69ac700bbcaa1c11d0b1bc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79c91bbd57ea5bda1db8f6eb7d110fe2f1c68c04743220428c511700f35c5768"
    sha256 cellar: :any_skip_relocation, monterey:       "3c52f0a133217dc8b3d791801419f3199ab8a20e531e19331ada93c79f8540fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d57a7e7b90d3d1cb883a5b10e8d58fa46ee575b4ea1e73803e2afc37ebbcc33c"
    sha256 cellar: :any_skip_relocation, catalina:       "ada6229907c23b5c61ab321701104e65e03f0a212bea27efdeced64d8f9d7381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39905e3d9ff86a5dd5d580558fbd90cff08b0168471b5395460fed739e899854"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "bash")
    (bash_completion/"kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "zsh")
    (zsh_completion/"_kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "fish")
    (fish_completion/"kumactl.fish").write output
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
