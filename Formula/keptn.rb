class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.7.3.tar.gz"
  sha256 "7c5ab4bce7f8c75371a6130ae7929a9c7a88d05f29b96604b3849a93d2177228"
  license "Apache-2.0"

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
        assert_match "CLI is not authenticated against any Keptn cluster.", r.gets.chomp
        Process.wait pid
        assert_equal 0, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
