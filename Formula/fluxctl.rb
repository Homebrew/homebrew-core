class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.14.2",
      :revision => "7fd090af0dd9b63acc9fa1c8616d5bf5657c6160"

  bottle do
    cellar :any_skip_relocation
    sha256 "21bad42323986e91a2f0f178f95025d26917bee47a45644befb7050040b9b8de" => :mojave
    sha256 "3758702dcf1455af361c4bb2344b4541072dc52dac593e9fe497b48217d0e979" => :high_sierra
    sha256 "d428f34c65016fab9a0f02b859a6fec69c5c6e3ffeea16589d9a35ec24f90dd1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/weaveworks/flux"
    dir.install buildpath.children

    cd dir/"cmd/fluxctl" do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"fluxctl"
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
