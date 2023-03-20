class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "b37e2aab0ae208e450b7d1363c1972c52de98e91164833b5c1207351af100a0e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5f9162f8b25785455aeec4c21acdbf0ad2b8282dbd48fa79b66f24739d54566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e59058a958f0658bff301132dfb171e5cd04b151863afefce33b0165e2876b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5f9162f8b25785455aeec4c21acdbf0ad2b8282dbd48fa79b66f24739d54566"
    sha256 cellar: :any_skip_relocation, ventura:        "39b4e913710b2d664fec08576683719db960fbacf392493ed58de2569355a61e"
    sha256 cellar: :any_skip_relocation, monterey:       "39b4e913710b2d664fec08576683719db960fbacf392493ed58de2569355a61e"
    sha256 cellar: :any_skip_relocation, big_sur:        "39b4e913710b2d664fec08576683719db960fbacf392493ed58de2569355a61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6caa4bd9563a73c0f401a341f3f134ff82b0a7ca47cccca8cee4a88664d84a76"
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
