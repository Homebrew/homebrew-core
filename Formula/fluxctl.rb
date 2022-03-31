class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.25.0",
      revision: "1f9a70ef84fc115d83f406ce12298c5892fe6afd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae8e2c8069e639637d65e48db682208ba716b4d929628b61b35adf6b603203c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0dc50dd0ec5bfc3e424ad1499bfcb2b30e152ca160a36122b60709ec62511d5"
    sha256 cellar: :any_skip_relocation, monterey:       "4957ff9c31c8c72b43905654c5bd59e1e12d547fe3d1a46f0e278e1e8aabc834"
    sha256 cellar: :any_skip_relocation, big_sur:        "3db920028523a47b8cb5fee6f4fe03c7afee0e7eae0e9c3a4f52f54104b376b8"
    sha256 cellar: :any_skip_relocation, catalina:       "0aea620bee684d2b921180ee9c9f5759906703d3e7d0fdf552ac3b8830756f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7c15e6212aa67cd451b89620f65ff330fdcb8ac392310b9503534482a0c64f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fluxctl"
  end

  test do
    run_output = shell_output("#{bin}/fluxctl 2>&1")
    assert_match "fluxctl helps you deploy your code.", run_output

    version_output = shell_output("#{bin}/fluxctl version 2>&1")
    assert_match version.to_s, version_output

    # As we can't bring up a Kubernetes cluster in this test, we simply
    # run "fluxctl sync" and check that it 1) errors out, and 2) complains
    # about a missing .kube/config file.
    require "pty"
    require "timeout"
    r, _w, pid = PTY.spawn("#{bin}/fluxctl sync", err: :out)
    begin
      Timeout.timeout(5) do
        assert_match "Error: Could not load kubernetes configuration file", r.gets.chomp
        Process.wait pid
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
