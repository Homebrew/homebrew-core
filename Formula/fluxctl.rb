class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.13.1",
      :revision => "b0cf5ec55ea207df1e184d929ab8879c8945b4c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa9eb92a281e5dd733a3a0a8b76aeecb560609c50c1aa55af82ecda0e01c3324" => :mojave
    sha256 "15b91c551509402ecbbd5a8e8cbbc2f89d1aeda692173e4b2e8d0025ecc875fc" => :high_sierra
    sha256 "8e75282788fb6e088d9fc4ec6840a93c636d36059a391cac0fc419ae7da0f4b8" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
