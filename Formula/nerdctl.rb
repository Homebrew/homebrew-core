class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "be19ceed51703a71f847bfff3afcf25e0efd4c012fd8ec1ff02c545d6773989d"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "da2510c479b32f0941da52137bc1025ad8a355fd1c76ccf17ba1976cff8acdfd"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/nerdctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end
