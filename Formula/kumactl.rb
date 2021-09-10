class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.3.0.tar.gz"
  sha256 "46dbf50f0bd02bddfe1927b70e74676401b15362daf3cd04a36be77f288d74c2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b9d8ad781820a31ca8cdf6e791b9b43c4718745e03e939ab553c4b87abb82ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "c25545f9ab60045da9606e2536b3a0ff5aee69bf58c24ff20fa41632a459c950"
    sha256 cellar: :any_skip_relocation, catalina:      "a5d303278c2933cb02c7ed2eb2c617a9064e464e0c4f303e10407399b1590eed"
    sha256 cellar: :any_skip_relocation, mojave:        "dcd4c2904ec91754b3bdb7b96b6c678f4e1e27b40f4726c3fcf06e26dff8689b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "011fe6300154d1f5ef0625179c2c21666d0e0a6bd0e04fdb69bc37e8043aa491"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ].join(" ")

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
