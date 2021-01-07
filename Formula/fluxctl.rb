class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.21.1",
      revision: "930a2cc43487033ac70e38f7389a2a573a55fdf5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "acd339d492ec7e1e159159cc87f46607e255ae22e13748196003298bd3be4566" => :big_sur
    sha256 "8cc8f23b89f87eabe8f8068275d46cfff5fcbd422082362c0a45949ba7e90e2d" => :arm64_big_sur
    sha256 "c4fc57db22d48f9d0abd9a077e4b9111eba82e08d6adb3db5edaf51751d0b893" => :catalina
    sha256 "e7942d1b174b0ff28a7fad0b8d1a72bdb13d739d5748d8a53a70986de353905a" => :mojave
    sha256 "554b1b055d2e4d3b650c5a5895b3e01a97606497cc7b6329225fc06ac8f88a49" => :high_sierra
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
