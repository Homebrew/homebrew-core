class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.25.4",
      revision: "95493343346f2000299996bab0fc49caf31201dd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c059cb7ecb8747a61ef8fc416bbe908a4b42efcbb020e48effc3beaa9bd0472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21b213416a61ed795b87fcb56ab7cff2fcd7142aebba9bc1a14978bb5b2e0d20"
    sha256 cellar: :any_skip_relocation, monterey:       "7808c99b3b5f1b0c541399b1733ad6e40075b447cb0874db8dd46d6583f5511f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d55de8657ae06d13b86d387653d672770280e9e5f56b6cc17e264914c1c21b3"
    sha256 cellar: :any_skip_relocation, catalina:       "4f9eca9faa6b11dd4986a7ffba7665702a69acfd80d97a9da65d16df38c8f34a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "870b2dcecf960807ddb6d5fa8e2e62b1a806dd13d0daac409e8aa7a65e593601"
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
