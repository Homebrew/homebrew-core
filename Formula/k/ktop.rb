class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "155d9bbe6d14e581d0679ccf042dd8dee6993a8af8a33a47febd0965836dcec7"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c0e169b6d9b11a128cf2ee5151fcfb31b8ef0a532f0e07a22d10f8815cc593e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d05f55ed9251d9a929b54e4b95919eabf4f2d58fc9d54ae235c5598f04ad6b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af100c7e7ac8b429dd1223b2178825a590fe818c90482fe0745dc81f6fc7b8eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0cfb63c90949e727de21bc30d49f174e74e5293287bc22be40474d3811a95b90"
    sha256 cellar: :any,                 x86_64_linux:      "b29b5f058c9c5427ec5c2e1b738d994a7812897cde539ee27a31684b7229cd86"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 3)
    assert_match "connection refused", output
  end
end
