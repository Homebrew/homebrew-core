class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.23.1",
      revision: "b9ad5e9cbd098f398ffe7177ec582b447fded727"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b4775744fa8e75249d90eea1ee851e67d3f1793c3286466e55fd8e41a732c0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "091dce033b92404641a50ef83ce0b9543432c4975d832303af2dbe3aa5b3aad5"
    sha256 cellar: :any_skip_relocation, catalina:      "9d1b109d5eb2b54672b80c0964a125d64f14b275c5b868e36cc59e4892f797cd"
    sha256 cellar: :any_skip_relocation, mojave:        "a15f548797baf170fd2aebb6a005e98c1d12f66126b35ede0845687910f0aeab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0147eaef10b49056a1121213607aa86e19e841f114ad0be517ad6f4230303ff5"
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
