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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faf3f4651f8793001138c39c8f30c8d7a13fc4bead081f8a07472e0bdfb07642"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd04ec8908d87cc59e08e7614b4aebd9f07bf4139eecd79ca1ed1df612a590a2"
    sha256 cellar: :any_skip_relocation, monterey:       "e4d0f2333d3d3671bc353c28dfdc6885abf873adf2ccfc7b8212cdceca249bd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdbb7962ebdbe15d248f4be471331a9e1fc1f7367458d0664f872729658eda02"
    sha256 cellar: :any_skip_relocation, catalina:       "8a15bc5da2545396178cd581eb0181241aca3769853694799a7941813a6507c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9affdf7201c630a9ba7ef6a951d3df9e1890d7a120eb00e0faca9e52b220dd2e"
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
