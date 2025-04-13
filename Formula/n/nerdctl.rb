class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "514a1f89e33311c626efd71d2ad1409180f57bbf5b4865ff776a44f7583c1dec"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "de7aea98fa53ac0ef9ed5627f228488a39a760c48848bf880278986c5e72fc58"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "757e0eeaca1b4d01ca5e815cafc314270ddd07b3a81a32033c7b40043aa7de12"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/v2/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdctl"

    generate_completions_from_executable(bin/"nerdctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end
