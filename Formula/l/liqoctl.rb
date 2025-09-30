class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "975ab68085088dd8c6f0b7006d48d34b38134915c8f0140cd75bb913a3259bd4"
  license "Apache-2.0"
  head "https://github.com/liqotech/liqo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dbf29d639a9ab6e771e5ebecfc0bcfa92b1f2688fd76e30c922d4b8ee85274e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d4a8e76acb9cf6af05542a8d547acd731694fd34a19b6d0b1146ef0e329deeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d4a8e76acb9cf6af05542a8d547acd731694fd34a19b6d0b1146ef0e329deeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d4a8e76acb9cf6af05542a8d547acd731694fd34a19b6d0b1146ef0e329deeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "694bfbd0a2326bdbd372bd3fc63d49db44de6ef4a0777b5e28f0746e06bf1915"
    sha256 cellar: :any_skip_relocation, ventura:       "694bfbd0a2326bdbd372bd3fc63d49db44de6ef4a0777b5e28f0746e06bf1915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0094019b44bde83381dce61c6aae88e610c3bea78508f7ef685c3ce2bdbe2de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "476a979f69df08fcf5928ae58a4d4e484ca817ee02fdc2baf3ef6bf6b342df15"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.LiqoctlVersion=v#{version}
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
