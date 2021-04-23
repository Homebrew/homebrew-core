class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.22.2",
      revision: "cf97726492f4b2d9585ded3bd83823ba4e65b272"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b4330f595fc510a251f60ee413f416fa2722720088c8c3840557351d66cc8b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "d16962e5a1610e8f80670c263cc1676b74757915f3fdfe3c3fc3b6653f2840c6"
    sha256 cellar: :any_skip_relocation, catalina:      "11272898db85606a1d172040bdf1d4312fb6abeaa5cdc824a5a9474f77e8f871"
    sha256 cellar: :any_skip_relocation, mojave:        "f0586caab8a8d8bc7ebae758698bb07b6c4d529233f1f5c1c5afa1cf9650bd49"
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
