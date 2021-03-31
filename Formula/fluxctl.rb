class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.22.1",
      revision: "25e2315de37865fcde7e8ad0acc5d72aa9f3017a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7fe6504d409ac951d3f77e5c04024acbccd3d5972b984718413a43fb52ffca86"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee31de88de6945e4c68a6a0308c38d16413206948968a4cc1c23312361cad5f2"
    sha256 cellar: :any_skip_relocation, catalina:      "2475d79e25ca4e3d429fdda50609d46ae99410d2977ebb048c487dd4e3dd6c23"
    sha256 cellar: :any_skip_relocation, mojave:        "8017a50f871b689a00273c1b7fcc1ca2ffa5b50ec4c3120b826e655cf0e26a40"
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
