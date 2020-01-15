class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.17.1",
      :revision => "0d3f1d3a2fa0655e2dc297793328d182fdf9e710"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c8bcbe327c1c6a295dcd0a84354e168ee0e28557979c0629084023ea2fa829f" => :catalina
    sha256 "f8e3234c0e7263ba982517a0247db4c48fb2baaf5d43e97070ff9cfa5c99acbd" => :mojave
    sha256 "546f03fdd9dd4ce93466b5ae3030f9c061fee102e5fac4770f4151d09f4419dc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd buildpath/"cmd/fluxctl" do
      system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"fluxctl"
      prefix.install_metafiles
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
    r, _w, pid = PTY.spawn("#{bin}/fluxctl sync", :err=>:out)
    begin
      Timeout.timeout(5) do
        assert_match r.gets.chomp, "Error: Could not load kubernetes configuration file: invalid configuration: no configuration has been provided"
        Process.wait pid
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
