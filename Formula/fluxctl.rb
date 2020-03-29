class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.18.0",
      :revision => "32a60f735385d570243f8c15f5b2b5ff460845fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5ad883cfc41d1e6a4c92f89856ada73a1cf0fb20a1f5a54f6d5bdc151d10e23" => :catalina
    sha256 "8c4dcb4cd50455cc9928f13fe9151df3daafe631c80d2ab843f3cc3080060532" => :mojave
    sha256 "163c3fbf008299ca24c3997c3c7e5499faf1d580b4db0e555bccbcb9d86d18e6" => :high_sierra
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
