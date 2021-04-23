class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.8.2.tar.gz"
  sha256 "eb20175aa8e2a56bc4c7311e34fd2d4046382111048f5fdae46a0d3488b13e01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e1a0740fe66a3c67c1a4ba6638849cc12c6ebf0686bcfc0db71d6e785ee063a4"
    sha256 cellar: :any_skip_relocation, catalina: "91b2633183164288ac640fbdff47b8a7bf6a04c8b864cd3c92a13c9aba103da3"
    sha256 cellar: :any_skip_relocation, mojave:   "c2028545946baf04ed42448fb5594cef24c99b2e33d2364462a33896080a0230"
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
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
