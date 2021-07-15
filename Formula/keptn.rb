class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.8.6.tar.gz"
  sha256 "6fa94966597b8c9235a8102b941d34dd46b77e18cb75a6a97d051b370067b3c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96c7544ca4a06821c87009ae8140923ab44d4f4a8580fc3eb61831c0c87b9899"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a22af9d5abc7f4df621a2573065c5193c324f34a7811b315b387003d587a598"
    sha256 cellar: :any_skip_relocation, catalina:      "ac5371e6a6969efc0ee4f9a99132fa4662b189ed371e653ea65995ede7c5342b"
    sha256 cellar: :any_skip_relocation, mojave:        "b451ed110bd0be5523681dfe4475b9c2e8ad15f2f34726b5d5eb1316556eb840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f165ad55a57d3a034a37e874de8033740340f77ee18bb7d2ee10c5cfab9136b9"
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
