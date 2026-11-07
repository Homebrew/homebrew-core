class Portop < Formula
  desc "Terminal UI showing which processes are using TCP and UDP ports"
  homepage "https://github.com/padovanl/portop"
  url "https://github.com/padovanl/portop/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "95413106c84c14e658e3e6992da78cd8892b1a11d83cfdb24da3b0dab9d667cb"
  license "MIT"
  head "https://github.com/padovanl/portop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b4889d3d68ca705e3a884bdbe6e2ead9aa91ecb940ef328c2a590e1d5755864"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b4889d3d68ca705e3a884bdbe6e2ead9aa91ecb940ef328c2a590e1d5755864"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b4889d3d68ca705e3a884bdbe6e2ead9aa91ecb940ef328c2a590e1d5755864"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4da77dadb1e6a7e4b227b95055701a4af3099f4238581128fbb98deee4bf40e"
    sha256 cellar: :any,                 x86_64_linux:      "25ff93781f5e43910f6118d1b4c87b881cf8e155b282fce9b0074db6f934f793"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/padovanl/portop/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/portop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/portop --version")
    assert_kind_of Array, JSON.parse(shell_output("#{bin}/portop --json"))
  end
end
