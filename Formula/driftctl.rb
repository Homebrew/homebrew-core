class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.34.0.tar.gz"
  sha256 "b8b75d0756f7e703a6bc3ad2c44de75f03402854eff28f0752a9eca80691c186"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c23377f154989cb9263d9053ff5410093baceae643fd1d752e51efc4e3c04ed3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c23377f154989cb9263d9053ff5410093baceae643fd1d752e51efc4e3c04ed3"
    sha256 cellar: :any_skip_relocation, monterey:       "c9f040d11f0500f6f1bb0d171dba803a24a03e48b9230c40d3c2cfdd5c155786"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9f040d11f0500f6f1bb0d171dba803a24a03e48b9230c40d3c2cfdd5c155786"
    sha256 cellar: :any_skip_relocation, catalina:       "c9f040d11f0500f6f1bb0d171dba803a24a03e48b9230c40d3c2cfdd5c155786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b146bc2b41954c22a082a39f8a1428b8ae5fb1ea7437fcdd532ff791b47860f5"
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
