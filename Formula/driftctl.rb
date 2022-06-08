class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.32.1.tar.gz"
  sha256 "11ad910ac8e97432a226d6f04880e6e395f6cb9e3031c2e92921d42ccdc44bff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "601a5661860ae463213de13185978da56e2832c6a9c572fd5227b611eff2dd62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "601a5661860ae463213de13185978da56e2832c6a9c572fd5227b611eff2dd62"
    sha256 cellar: :any_skip_relocation, monterey:       "fd3f447e7937feb8fdae2dae7669522d9d91950b289f0d9b5947bfd78571e18f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd3f447e7937feb8fdae2dae7669522d9d91950b289f0d9b5947bfd78571e18f"
    sha256 cellar: :any_skip_relocation, catalina:       "fd3f447e7937feb8fdae2dae7669522d9d91950b289f0d9b5947bfd78571e18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9124dacae0ad28f4775c277aef99a2ffccaadde0659a9edb37603e99122aa12"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/snyk/driftctl/build.env=release
      -X github.com/snyk/driftctl/pkg/version.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "bash")
    (bash_completion/"driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "zsh")
    (zsh_completion/"_driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "fish")
    (fish_completion/"driftctl.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Could not find a way to authenticate on AWS!",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)
  end
end
