class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.20.2",
      revision: "a35b978174606c7290a3a64438b8bb3eeb3fd6ea"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9dcd9706aab0ecb1c7c9be4bc2cf2e4b50f8b041d645da01a3d59abb2d46720a" => :catalina
    sha256 "e0e0c9a81d19da4e8271d7250250bb2f340427e21c4308e55d3d0f0c56675676" => :mojave
    sha256 "71b9eccf90a9a687916e74ae6c8def06e84d6ccfd0a569b14f6bf9b86ae1f531" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd buildpath/"cmd/fluxctl" do
      system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"fluxctl"
    end
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
