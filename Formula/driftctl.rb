class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.14.0.tar.gz"
  sha256 "c5b573de08016de28bcdd95e1b0cf9a0524a5c3a97a2adfa66c66749831df3d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a55ab1cc42e5010367d1026de7423f29310c6011236cbfa2b0859b966c7d272"
    sha256 cellar: :any_skip_relocation, big_sur:       "c7376fbebbbf5fc5a4855e5f42363206879e9f047d955d415db82cb0c9ff2080"
    sha256 cellar: :any_skip_relocation, catalina:      "c7376fbebbbf5fc5a4855e5f42363206879e9f047d955d415db82cb0c9ff2080"
    sha256 cellar: :any_skip_relocation, mojave:        "c7376fbebbbf5fc5a4855e5f42363206879e9f047d955d415db82cb0c9ff2080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56cbf929571bc513936abeac9c2c87fd3d2c09fbbd778c59b8275faafcc8a24a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/cloudskiff/driftctl/build.env=release
      -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}
    ].join(" ")

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
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
