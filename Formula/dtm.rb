class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "06b95847dd619404e5171f410a922724d7d654ab0bb4c70681cb3ae510db11c5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1f415da04ba020ecf96c538edbce7facc48bceea9ce91260b30c36c89a56d6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce25c31cfed6a952fdc787b2540b9bad07ef739b437ff8834ca9279b8fe2553a"
    sha256 cellar: :any_skip_relocation, monterey:       "3aabe6c4bd07c2f03f46fc3b86ebd499c75667d2bc4df35acdc189e304e9d745"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dd201dcd86af788cc284b561d9cc7ce4e0f4b925b5877de6ac88398410ff768"
    sha256 cellar: :any_skip_relocation, catalina:       "988e8eb6e80ce787b028a779efae2f241c01cf4611909a3aedc91a8a5a2aed60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca1fde455eafe3c7ddfcf5987e182260d9d2a4056a32ac80f548038d10eba960"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")

    http_port = free_port
    grpc_port = free_port

    dtm_pid = fork do
      ENV["HTTP_PORT"] = http_port.to_s
      ENV["GRPC_PORT"] = grpc_port.to_s
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    metrics_output = shell_output("curl -s localhost:#{http_port}/api/metrics")
    assert_match "# HELP dtm_server_info The information of this dtm server.", metrics_output

    all_json = JSON.parse(shell_output("curl -s localhost:#{http_port}/api/dtmsvr/all"))
    assert_equal 0, all_json["next_position"].length
    assert all_json["next_position"].instance_of? String
    assert_equal 0, all_json["transactions"].length
    assert all_json["transactions"].instance_of? Array
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end
