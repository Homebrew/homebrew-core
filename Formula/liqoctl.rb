class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "b93e301fea2e8d14c13a26a8f9ba950edd8eb3aad4f165abc3ffffa1e6adcf72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d5ba2ec39f27f2c4f47d0fe48c0be431d9a0ca70ab594e96521db829ad45927"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d5ba2ec39f27f2c4f47d0fe48c0be431d9a0ca70ab594e96521db829ad45927"
    sha256 cellar: :any_skip_relocation, monterey:       "39a39ce3e2297dd5db6d528ae42e5821d58be76e1a644c43008b130dbf22b2ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "39a39ce3e2297dd5db6d528ae42e5821d58be76e1a644c43008b130dbf22b2ef"
    sha256 cellar: :any_skip_relocation, catalina:       "39a39ce3e2297dd5db6d528ae42e5821d58be76e1a644c43008b130dbf22b2ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14b1421b9ed7e36dc8c29090b76206434e3f154f28ce41bf37fc09e4eda0e3a5"
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
