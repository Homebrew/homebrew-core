class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.8.5.tar.gz"
  sha256 "a1933ea59045b5660d08cace0c2c5c76538cd2a2455c4d6d3ec3d541601315ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "946bcaa88fb110ff7f4e47ce47c3fcd3c90005abdd7c4ea92e2225a0be2f72d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "6fdc84f3fc3ee28e7b4b96051b7ba7a7c4c7e5ec2645c37b6c5a4d826434cbfd"
    sha256 cellar: :any_skip_relocation, catalina:      "68c3db5ec14ffb51e43e3eef20b5f9639ae31033c4cad60044f3b3d8389699a6"
    sha256 cellar: :any_skip_relocation, mojave:        "9b47a13b6d951c5133ff89cb2a5c215b20c0bf671901abdd68f8312d224042e9"
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
