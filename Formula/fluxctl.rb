class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag => "1.8.0",
      :revision => "9f2be4bf2d762034a5118a0a7e974bf91089afea"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef7fa7a2780d0242559f9fa0bf887face52f0bff2fcb9cc91e04260291390272" => :mojave
    sha256 "8f195ceb9f1150729e1f53ccccd2e99beadbd280e31d045b44b2212189fb00a0" => :high_sierra
    sha256 "33e068bf2969b3f6bd5812c858f2e0bbe8b62f60854555aae490826d76e2693a" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/weaveworks/flux"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make", "release-bins"
      bin.install "build/fluxctl_darwin_amd64" => "fluxctl"
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
        assert r.gets.chomp =~ %r{Error: stat .*\/.kube\/config: no such file or directory}
        Process.wait pid
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
