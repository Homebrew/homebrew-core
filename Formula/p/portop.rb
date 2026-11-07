class Portop < Formula
  desc "Terminal UI showing which processes are using TCP and UDP ports"
  homepage "https://github.com/padovanl/portop"
  url "https://github.com/padovanl/portop/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "95413106c84c14e658e3e6992da78cd8892b1a11d83cfdb24da3b0dab9d667cb"
  license "MIT"
  head "https://github.com/padovanl/portop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "868c8700c1e4715ebe39e78ca2f05cbf97d9641174fabeb14d79f1a9b943b9cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "868c8700c1e4715ebe39e78ca2f05cbf97d9641174fabeb14d79f1a9b943b9cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "868c8700c1e4715ebe39e78ca2f05cbf97d9641174fabeb14d79f1a9b943b9cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8d082622dfc0129d267f76f77757c41c1b3060bb4310ba0011166dd911d1578"
    sha256 cellar: :any,                 x86_64_linux:      "fd4c8331a687a05467e07c367cffc59e250eb7181dcb381a52f0230837f7e4fd"
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
