class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "50b9b6b9e62c7ac168130c15b6363eb46463e6cf0e1561bd24b015611351effd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c8aa7b32114cc2ce1d8309596dd99347462b072bab2873e6038a3317bad0a7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c8aa7b32114cc2ce1d8309596dd99347462b072bab2873e6038a3317bad0a7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c8aa7b32114cc2ce1d8309596dd99347462b072bab2873e6038a3317bad0a7c"
    sha256 cellar: :any_skip_relocation, ventura:        "97df6eb38c02bf972979779433bf0bf08649e4421de55f97b5f98310a65f9957"
    sha256 cellar: :any_skip_relocation, monterey:       "97df6eb38c02bf972979779433bf0bf08649e4421de55f97b5f98310a65f9957"
    sha256 cellar: :any_skip_relocation, big_sur:        "97df6eb38c02bf972979779433bf0bf08649e4421de55f97b5f98310a65f9957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffbf6e047245f598b5af1b4da9c5fbb6f9b0f5ab79668b11ae6af51ab0be6014"
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
