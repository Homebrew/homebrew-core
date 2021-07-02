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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfa40edc648e108d3fd498b5317211f0d1d6118c911cfd77b02b0a7f7f5a4a79"
    sha256 cellar: :any_skip_relocation, big_sur:       "950d8dd21239d7c4a819ee99a7826ea6df10b8bd7a12e32c70e7eaa2881b1955"
    sha256 cellar: :any_skip_relocation, catalina:      "b998b38934d6d7e599c3815fa706473d3a0424bbcbe5eb25618c98a788d0555c"
    sha256 cellar: :any_skip_relocation, mojave:        "bfec9c7375d179e3cd1ca55b964cbb8227e5178d48939ccef30c70656ae1a312"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{Date.today}
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
