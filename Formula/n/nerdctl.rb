class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "f39c34d3a285e087f2b2869f06fea343d8285ad9bfb9417b9c5b6dd4e78d6fad"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "988e4dc5097b4de4101f5cccd25de622b9d2871f4579b3ddb59863df5e640dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e52decf20eb724537a3eb99dfebd44b23d07336ed86f67cd7d90430767fc5b9e"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/v#{version.major}/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdctl"

    generate_completions_from_executable(bin/"nerdctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end
