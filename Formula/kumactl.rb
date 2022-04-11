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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed843de116e1349b0078bfee12782667f33fdc8757bb825fe6e29d88feac888e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ce05952cc9d9c4d05b79bd57917010d83563aec4de74cf010992373f6b79738"
    sha256 cellar: :any_skip_relocation, monterey:       "503fe91a1e9423e6d42c8aa41ac7671e354fff30253f80f1dfc6c104f8494322"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b31e22ee6a2f04a7a945a22de303c281334b977563f335dac15db4dfe4e55d0"
    sha256 cellar: :any_skip_relocation, catalina:       "c68bdbfaf7dbdf4e88d5fa0b133b553e3f7578490f5dbd47b3df0ce269e29047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "346d1d1ed9cf495badb80f3578338214dbd5df9ff0ebc0cd548c145756152802"
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
