class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.32.1.tar.gz"
  sha256 "11ad910ac8e97432a226d6f04880e6e395f6cb9e3031c2e92921d42ccdc44bff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4e1a17ba48c29ceb60be662bd16418cc05db6317d2a11b26653d89972a82b8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4e1a17ba48c29ceb60be662bd16418cc05db6317d2a11b26653d89972a82b8f"
    sha256 cellar: :any_skip_relocation, monterey:       "2059977303414c3c9d26f8b0c4426a0881696d70dc4f1573bacd79855c14f3fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2059977303414c3c9d26f8b0c4426a0881696d70dc4f1573bacd79855c14f3fc"
    sha256 cellar: :any_skip_relocation, catalina:       "2059977303414c3c9d26f8b0c4426a0881696d70dc4f1573bacd79855c14f3fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bcfaa265656964b572f0865348d49c7fe8a53bc72928dba00b8db81a2942fa6"
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
