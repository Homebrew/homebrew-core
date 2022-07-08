class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "6d7c140e7bb4e7ba3b4c041de656c8340c8c0f90d4b1f3ca81715684899825ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebe9ee1a1d0e0df1ec22d3cc27b81f5730511ac51af837717ac51cc66c58a96c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebe9ee1a1d0e0df1ec22d3cc27b81f5730511ac51af837717ac51cc66c58a96c"
    sha256 cellar: :any_skip_relocation, monterey:       "692f3763866e821a640116267b755b4f87d7874e34a2ad5a7eb5a13f895d9266"
    sha256 cellar: :any_skip_relocation, big_sur:        "692f3763866e821a640116267b755b4f87d7874e34a2ad5a7eb5a13f895d9266"
    sha256 cellar: :any_skip_relocation, catalina:       "692f3763866e821a640116267b755b4f87d7874e34a2ad5a7eb5a13f895d9266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9cf71f210205fbcce1120b4b4050eb7c353f2935a17c876f23119d7d4bb4c4"
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
