class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "224d5e6e9e503b5f014b0d0c545fa7225f2c3235b24abba900bb4a54efadb81e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8046e2dc4fff6b1a0b81b660bb1bd3bebfbe870ab4ed4ff8e4b4ded6fa0ca921"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8046e2dc4fff6b1a0b81b660bb1bd3bebfbe870ab4ed4ff8e4b4ded6fa0ca921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8046e2dc4fff6b1a0b81b660bb1bd3bebfbe870ab4ed4ff8e4b4ded6fa0ca921"
    sha256 cellar: :any_skip_relocation, ventura:        "081113eac5981450f1bd7472a0ea6f8652b32485851f5f70d86cb44a0a618f04"
    sha256 cellar: :any_skip_relocation, monterey:       "081113eac5981450f1bd7472a0ea6f8652b32485851f5f70d86cb44a0a618f04"
    sha256 cellar: :any_skip_relocation, big_sur:        "081113eac5981450f1bd7472a0ea6f8652b32485851f5f70d86cb44a0a618f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93af5e4cdc0adab8d43610087a8b57ceebb15b395cb6f8280c64e3b49b0dbdf"
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
