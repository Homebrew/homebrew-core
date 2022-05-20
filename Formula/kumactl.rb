class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.6.0.tar.gz"
  sha256 "5dfd6c561a0b3e190868df00f4ec4aa93a9ba159cabe982b98b20c5c0c5df6aa"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "431e4143042fc3f8282fea7c28d908172a767f6115b236c00d8d19d744d32efe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2e93ba62d3ef2edfe16b3e6efa9f7dff9164ecb866c735f2f2ac38c88bfc71a"
    sha256 cellar: :any_skip_relocation, monterey:       "fd1d4cdc2ab6035a9525aa8d491bcef64373efb2b159ef20ae0cb427f2efebd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "68517bebe15442c24691e63d2aba4fce2ca5cad73fc168dee01807b70d443804"
    sha256 cellar: :any_skip_relocation, catalina:       "ee185641e1e05f717ccd18825514f72aca1db198578f920ec29581a7af6d4541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948fc00a865eaaa7986cf930fbb8c8fed192926016c761c89a7bf0b2ffe7b9cd"
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
