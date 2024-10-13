class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "bcddf2ee3ad2bc84adc5e207f97157998fe973912c7d1dd9540bd4bb4a07698d"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "09d45663a7ae0661ddb4c4a28071d2da6ea00e3d8139c40dd771cc2a9816aed3"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/pkg/version.Version=#{version}"
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
