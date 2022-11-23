class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "6139e9cf9d85a9a0f5c6b1ea6d05e911f88a8c45228c709a1f3f3c4d88b955ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ae44ed71dd521a98f047800c50300d39583b311049af8732536dc279a9060b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ae44ed71dd521a98f047800c50300d39583b311049af8732536dc279a9060b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ae44ed71dd521a98f047800c50300d39583b311049af8732536dc279a9060b2"
    sha256 cellar: :any_skip_relocation, monterey:       "a5186e15337ba18ee734a5ad2a85ed0886e276c2073377098a4f696f4018dc80"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5186e15337ba18ee734a5ad2a85ed0886e276c2073377098a4f696f4018dc80"
    sha256 cellar: :any_skip_relocation, catalina:       "a5186e15337ba18ee734a5ad2a85ed0886e276c2073377098a4f696f4018dc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f881c287a39bc54612f846e746ad75354868d9703c0b92606fde939ffabf5ce"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
