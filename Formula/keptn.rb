class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.8.4.tar.gz"
  sha256 "506736a657b77146ee5b41b9e98123ca5f75d70da17f13a4c5f85ba03e7a7022"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96b9060be1fc7ad8522d52f043c382e9f6563ca52fd40984088a30a7514a8137"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c08935654a5ba37098d6bbe74ae148824cdcc21889f22f171e6b9c4a44a4ffe"
    sha256 cellar: :any_skip_relocation, catalina:      "59a1ffc854e5420805254a0b2fbc47139d2b8ffb7cae810a86c53982a43d8cef"
    sha256 cellar: :any_skip_relocation, mojave:        "ae383c334b33874359c6bc054b2e132da3e3e97b0d2d17b935cfed145cfbdc34"
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
