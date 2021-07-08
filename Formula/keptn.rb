class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.8.6.tar.gz"
  sha256 "6fa94966597b8c9235a8102b941d34dd46b77e18cb75a6a97d051b370067b3c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "033942f867129666d7cdd2c56fc0ac708734bcd82d545762b52f2e45debb6403"
    sha256 cellar: :any_skip_relocation, big_sur:       "db665fb0c9317fe8f3b2946e5f8f93c4f574371ab69450e8b7da2c7cf343974a"
    sha256 cellar: :any_skip_relocation, catalina:      "cd93ded1af08115b7c2711b8e398dc61f2f310588c27b6037cea787eb4132f14"
    sha256 cellar: :any_skip_relocation, mojave:        "6b5fa5ee9927e5ecad4b608f93db33bed6b5a023ff77edbd672824a24e76baa0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ].join(" ")

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    run_output = shell_output("#{bin}/keptn version 2>&1")
    assert_match "\nKeptn CLI version:", run_output

    version_output = shell_output("#{bin}/keptn version 2>&1")
    assert_match version.to_s, version_output

    # As we can't bring up a Kubernetes cluster in this test, we simply
    # run "keptn status" and check that it 1) errors out, and 2) complains
    # about a missing keptn auth.
    require "pty"
    require "timeout"
    r, _w, pid = PTY.spawn("#{bin}/keptn status", err: :out)
    begin
      Timeout.timeout(5) do
        assert_match "Warning: could not open KUBECONFIG file", r.gets.chomp
        Process.wait pid
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
