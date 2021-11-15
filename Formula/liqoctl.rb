class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4a89c95613d6a2083987aa29bf76eac0d42ae894e422e3995d039fe8c7b3b2d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eafea4903f2690e2db530d337f9c0f0441ff06a14633e5f423d6851053ba3d46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eafea4903f2690e2db530d337f9c0f0441ff06a14633e5f423d6851053ba3d46"
    sha256 cellar: :any_skip_relocation, monterey:       "d30f8e2a9f33d822770a88e736c64811823e637d87062e12f62bae88bba5f6e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d30f8e2a9f33d822770a88e736c64811823e637d87062e12f62bae88bba5f6e8"
    sha256 cellar: :any_skip_relocation, catalina:       "d30f8e2a9f33d822770a88e736c64811823e637d87062e12f62bae88bba5f6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d29bdb39cc84e1ea2ba1050ec5251c76b9b31aafb42aeb949e72a62cdb417ea9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/liqoctl"

    output = Utils.safe_popen_read(bin/"liqoctl", "completion", "bash")
    (bash_completion/"liqoctl").write output
    output = Utils.safe_popen_read(bin/"liqoctl", "completion", "zsh")
    (zsh_completion/"_liqoctl").write output
    output = Utils.safe_popen_read(bin/"liqoctl", "completion", "fish")
    (fish_completion/"liqoctl").write output
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo-enabled clusters.", run_output
    run_install_output = shell_output("#{bin}/liqoctl install kind 2>&1", 1)
    assert_match <<~EOS, run_install_output
      Error: no configuration provided, please set the environment variable KUBECONFIG
      Error: no configuration provided, please set the environment variable KUBECONFIG
    EOS
    assert_match version.to_s, shell_output("#{bin}/liqoctl version")
  end
end
