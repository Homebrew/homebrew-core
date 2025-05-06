class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "ad09ac253a46ce5bed1f9979f5a438dcf0b4b54e26f3c3e3134aa4c868db2362"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "27bfda606cac4b6fedafb9536a03c65290ad9bc587539bc5eb4d4871b9681a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5bc576ff83ed99a20bad00eb5c588a5096883678bfbfd30435ce3c13428c3650"
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
