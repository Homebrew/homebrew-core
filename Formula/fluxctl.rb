class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.17.0",
      :revision => "ab466af1ca98e8ad99ee016d8cdf666171a948bd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "35ee96b930f1918e28c8a62c17dd152a059be84313be201bb0c6a65469c850d7" => :catalina
    sha256 "334fa0b02b60d9d34be4f431ae4221b20c5b6312484a58ca96d20ccb9fbfd8ff" => :mojave
    sha256 "0efc9c42b78326fb7fd50942ad04ee58a1648b91d46714330e11852be021ed13" => :high_sierra
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
