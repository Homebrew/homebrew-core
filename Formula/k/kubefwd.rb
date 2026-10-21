class Kubefwd < Formula
  desc "Bulk port forwarding Kubernetes services for local development"
  homepage "https://kubefwd.com"
  url "https://github.com/txn2/kubefwd/archive/refs/tags/v1.25.18.tar.gz"
  sha256 "5c6e0f7a9407729a0fd948078b259790554eec9a15506c935083e688c3cbf371"
  license "Apache-2.0"
  head "https://github.com/txn2/kubefwd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5589c67ebb429b699dacb123d1ff919f4c33538259c4937173f69b4d3a1f3246"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7cfded812f4412a791c339acadd33e8688d2b8176e7f2dea030d7fbe14354293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c009b30d2a3732a101908da60cb085cf379a833d64023968595083c491e93bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66341215f9fb23d18723db0ed89e50b34e642b92391d458b4fca98b89c5afb4c"
    sha256 cellar: :any,                 x86_64_linux:      "783ed3d69463b63f0904b80fbb225ed1963481748284b46a9bb5637b903781af"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubefwd"

    generate_completions_from_executable(bin/"kubefwd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubefwd version")
    assert_match "This program requires superuser privileges to run.", shell_output("#{bin}/kubefwd services")

    output_log = testpath/"output.log"
    pid = spawn bin/"kubefwd", "mcp", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Cannot connect to kubefwd API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
