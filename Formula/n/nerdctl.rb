class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "f9c66b5a62f3a4967e246f10b06892ef9d08e3b2bfddd2be0b7346c8c47c05b5"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a47a2c42e93aaf08bdef2c7f596e2f6ed6c0190d81fcf44a109cfe4e2a73d616"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "50b930a2c3d360ddddd0144fbb85f9b94f22ac2c463fb269de1bae5e61d04dff"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/v#{version.major}/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdctl"
    bin.install Dir["extras/rootless/*"]
    doc.install Dir["docs/*"]

    generate_completions_from_executable(bin/"nerdctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end
