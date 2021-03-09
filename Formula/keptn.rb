class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.8.0.tar.gz"
  sha256 "91fb9dee635f446c8a3adf8cb1cf1a3c80ade96230a4e994247aed42f176f489"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5a6cff0dfb605514ab2530bf6b1e95ecfbfc598ce3a843263e75bb33df806346"
    sha256 cellar: :any_skip_relocation, catalina: "5093a00ef3fb4ef279966d85a52e1640392c228332429e6169cdd0e7adf76342"
    sha256 cellar: :any_skip_relocation, mojave:   "6c8bdf7816c311f7170d901c7e52a286ec9cc25047749cc93fde21777d4bfb9b"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "auto"
    cd buildpath/"cli" do
      system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version} -X main.KubeServerVersionConstraints=\"\""
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
        assert_equal 0, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
