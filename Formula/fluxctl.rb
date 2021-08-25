class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.24.0",
      revision: "b7cc57ee6875ca15f8c9a7e154da762ba715fb5d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3e25eb43fbd2870e76e4a9fbafc9f474bfe0d95b29ec6f094de2b8763ffe092"
    sha256 cellar: :any_skip_relocation, big_sur:       "1cc70fa6b1af33aa23edfa983e82ab33630418bd4bd2330bc5dae22580a9e080"
    sha256 cellar: :any_skip_relocation, catalina:      "b98657dffe0ad6c5885a321f598bf82bbba21a6a7ee7ce648ac2a0a2ee8dff8f"
    sha256 cellar: :any_skip_relocation, mojave:        "83ddfb17fa9a3a3bffc08bf4ab615f52082b290bdf20f76014df9eb5ff8c584d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a391f7f98c396fbf2a4fb0a890494b72d8a6de5524f183e9bd12bb76d9bf88"
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
