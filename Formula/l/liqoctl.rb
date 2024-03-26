class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "865c949f97794639074e2d1c87ad05ea8d71e0ec0109f31ff27ba305bb10ca49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f55b4b3b4261135089fc5532cc5efabbd33082869ab874de207df0d4071259c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f55b4b3b4261135089fc5532cc5efabbd33082869ab874de207df0d4071259c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f55b4b3b4261135089fc5532cc5efabbd33082869ab874de207df0d4071259c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3db5fb1bc21f45a1f5cb939656e7b40813702b02b2676c0d91497ddf2202a304"
    sha256 cellar: :any_skip_relocation, ventura:        "3db5fb1bc21f45a1f5cb939656e7b40813702b02b2676c0d91497ddf2202a304"
    sha256 cellar: :any_skip_relocation, monterey:       "3db5fb1bc21f45a1f5cb939656e7b40813702b02b2676c0d91497ddf2202a304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8103dc8395f92a43cb87fac263e76cadea7a7f6efbd0d76cfd07e4b04c2cd823"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
