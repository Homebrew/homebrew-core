class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "6834cf5888f8f1d28da27f0284bd1b31ca01bddcdb13bb9697aa24043f5a1cec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cfa4ac6a79eb5a877fe4819868e6f473384c9070e0c1fbfa134dec03c612a5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cfa4ac6a79eb5a877fe4819868e6f473384c9070e0c1fbfa134dec03c612a5e"
    sha256 cellar: :any_skip_relocation, monterey:       "be2cd231858a7ce57e8fb5535a6a61fbd25c6b136f01c3ff4453e4ae2382ae1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "be2cd231858a7ce57e8fb5535a6a61fbd25c6b136f01c3ff4453e4ae2382ae1c"
    sha256 cellar: :any_skip_relocation, catalina:       "be2cd231858a7ce57e8fb5535a6a61fbd25c6b136f01c3ff4453e4ae2382ae1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51623471fabc6d8a2e11ec8a57bf2bd163db170a2e8feeeb666e1ad150951128"
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
