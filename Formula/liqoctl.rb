class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "033a0edc30faac340abd6a912292af0942213693c2853c1024e740bdfd4d5f38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33ad718639a576a686e16202ac66af5369eae6a92f3372d1079aecab3e4299b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33ad718639a576a686e16202ac66af5369eae6a92f3372d1079aecab3e4299b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33ad718639a576a686e16202ac66af5369eae6a92f3372d1079aecab3e4299b8"
    sha256 cellar: :any_skip_relocation, ventura:        "a20b52ca648b5fbdb7668b43f84fa4c13df0cfcb434e404c774b0561e49ddaf3"
    sha256 cellar: :any_skip_relocation, monterey:       "a20b52ca648b5fbdb7668b43f84fa4c13df0cfcb434e404c774b0561e49ddaf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a20b52ca648b5fbdb7668b43f84fa4c13df0cfcb434e404c774b0561e49ddaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aa043426f8a164d4f35d6216fc1ac8039454849d5114d44e6db0298b36225cc"
  end

  # upstream issue, https://github.com/liqotech/liqo/issues/1657
  depends_on "go@1.19" => :build

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
