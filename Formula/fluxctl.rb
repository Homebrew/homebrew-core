class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.21.2",
      revision: "9da931586cc857b2c9204b5f02725211661aa412"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc6225abc9cdc012a29d432265de46efe9281908d2c6a6442d9bcbd8716da037"
    sha256 cellar: :any_skip_relocation, big_sur:       "6aabe7d9d1eca738b375080ad8bc7a582e18d67c5192e4766b8dee4f26553c85"
    sha256 cellar: :any_skip_relocation, catalina:      "ae61df8c796c94b342f492871709c12f90a094cd8430ef1a0832ea6450ebc7ca"
    sha256 cellar: :any_skip_relocation, mojave:        "805e695178bfd10fee90567f28a25b646b3f15fa528183e57aac1f1d915378e3"
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
