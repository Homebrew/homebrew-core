class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.5.1.tar.gz"
  sha256 "63696c1ec1f40f6160f5ce23082c6793fb030cbf1646017dcc346b0d8bb91e8a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a4a41b4740b066e45a9f892b75ae54a32a9b2fa6e7c91edbe9b1e40b17aa27d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b9503ed993b545f02c6d119004040f64b04b50cc6596f809fc44775a14ee1d5"
    sha256 cellar: :any_skip_relocation, monterey:       "dd3b4cbeb86163040647b65859adee39d9e90f6b9571c218a6a6ae2563a723c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "740d059cc9713fdddccb9501a292cc125c8bf111dc7f11e5b4e283f8ffec1bf5"
    sha256 cellar: :any_skip_relocation, catalina:       "d3c097c7f2882d5a7352772088b6ff037c47fb7f965ac3a60fbe42c3c79ff17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc0d17db949dd253a0ce4d2a15dc9893766ab0bfd5359519841c6e57a006cafb"
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
