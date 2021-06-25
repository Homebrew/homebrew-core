class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.23.0",
      revision: "913fd639ef8bcbf6ef8022d63868c816017aebf3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a5b853711aab8890160b2d29f9460b4274154331abe2dc2ab9d6eef3383c1f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "7fb226fef1a99a861f5ca5e4d0e2740076ef3fd96d5353f42429cafebdfc474c"
    sha256 cellar: :any_skip_relocation, catalina:      "a5d5ec6aef86b4ef13afd05e3575db6dcdc47f2eb9368a18cf16b588d14f49cb"
    sha256 cellar: :any_skip_relocation, mojave:        "a754f8206d5ef9a7247db6d5a0caa78065dfe350ece33d4549d2999df751e69b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/fluxctl"
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
