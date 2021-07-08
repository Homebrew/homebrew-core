class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.2.1.tar.gz"
  sha256 "9ff8b59f5fccb87862c2f78baa18f599b9a5d7acfbfcfd86d6bbdaa8997eb90c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f51f664c4067ca52902beab8570039c54af52b977541c480e010078130f3507"
    sha256 cellar: :any_skip_relocation, big_sur:       "94628da2fbc2a059404014b0a123571805cdfdc9c15078ca87e8fc58f173a096"
    sha256 cellar: :any_skip_relocation, catalina:      "531bb550e64a0c45c3310a28222c409bdbbc364dacbff2ebd9eb1d92e845b2ee"
    sha256 cellar: :any_skip_relocation, mojave:        "3172d5cf04ee572c99c93edae5f10449e21eb2302ac309c497c093ac4af34c99"
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
