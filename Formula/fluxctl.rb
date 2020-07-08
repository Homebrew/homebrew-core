class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.20.0",
      :revision => "04e9e50311c3bf407629b0a9d75996ead187e952"

  bottle do
    cellar :any_skip_relocation
    sha256 "da417f17fc62357716eb3030f0661531ebbcc3abf65a627d555ff05541968109" => :catalina
    sha256 "6b57426d070a0049ec7578fe1aeb7a2cb90863c76019a7056ad406d67e731b9b" => :mojave
    sha256 "de762c286e68c2870a6eb1d93bd8dcfb4f85c9d294efb469c7c09a2e0c3b7807" => :high_sierra
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
