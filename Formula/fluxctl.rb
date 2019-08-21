class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.13.3",
      :revision => "e6545951f7b18a518976fd784cc393e355d316a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4443e1db29e311d597a70d40ce632202d28fa6770c980393d909ea482396442" => :mojave
    sha256 "8e1ee6ef6a7703a450f979fd5f0f184316bda7926eaad1ef0ec4d53ad26db837" => :high_sierra
    sha256 "a254aa885ebcc393ba572b3f029a04d403ca2824e2aa0772ca95645ee10bab9c" => :sierra
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
