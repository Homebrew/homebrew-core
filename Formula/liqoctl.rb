class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4a89c95613d6a2083987aa29bf76eac0d42ae894e422e3995d039fe8c7b3b2d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4f60e00ba9c591f7b4628dbae97eed5e4015ee145f614bd91ccea3f1f60ad0f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "0e3ff868e626e694e7a99cb019fa4c8168ce63707d9507794e414e6d64c87b65"
    sha256 cellar: :any_skip_relocation, catalina:      "0e3ff868e626e694e7a99cb019fa4c8168ce63707d9507794e414e6d64c87b65"
    sha256 cellar: :any_skip_relocation, mojave:        "0e3ff868e626e694e7a99cb019fa4c8168ce63707d9507794e414e6d64c87b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58aa8f09f2e9eeab4292829d8a09c2f33b16482864a8676ea7f4536e75138416"
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
