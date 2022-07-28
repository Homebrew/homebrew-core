class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "d53935cc0f82d7562adabdb60614ffdb76bc944cab5d2df087e1046379e1f63f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "233c7c2444c22155d94d9a588b8281b6db211a1e1f94dfecd1d5f41c7ba215d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "233c7c2444c22155d94d9a588b8281b6db211a1e1f94dfecd1d5f41c7ba215d5"
    sha256 cellar: :any_skip_relocation, monterey:       "f14bc62a0bbe49efdf6f88885142476086625d09faaad38dac7c213443250166"
    sha256 cellar: :any_skip_relocation, big_sur:        "f14bc62a0bbe49efdf6f88885142476086625d09faaad38dac7c213443250166"
    sha256 cellar: :any_skip_relocation, catalina:       "f14bc62a0bbe49efdf6f88885142476086625d09faaad38dac7c213443250166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfde72bed08bb714cbf7e18d3ab34448ae02ad75671dbb85481adcd657a49900"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

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
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
