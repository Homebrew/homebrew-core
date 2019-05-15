class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.12.2",
      :revision => "e366684a9e995d447e6471543a832a325ff87f5a"

  bottle do
    cellar :any_skip_relocation
    sha256 "408e50fdec0a29a581055a3b7b751679647a145185c67e1a8b66e70c21cec0c5" => :mojave
    sha256 "ad748e1cbe10ca7a03810ec0dbd5ce411d86335a694f1dae0558854bf1e6b62d" => :high_sierra
    sha256 "58e4ef3cddc89d3ef8d26c06e26e59a26ca31611831b82b959a010be93af58a2" => :sierra
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
