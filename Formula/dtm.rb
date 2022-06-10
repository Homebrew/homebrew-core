class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "8de9adc52558c1913ceb5af550870716ee8125aeded182187a11e44df1089752"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c57235b8a7b5a8349a04a9ee2f0965b710ff0736b7094e02bbaf5c286df39eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21bf396e82caa56b5a5c75a44cc0f7fc2a20693727bedf9c19d56fb4dc344568"
    sha256 cellar: :any_skip_relocation, monterey:       "209572528a0c513ad47eb561fb16c3a2ee138ce796079d0de613f54e467db502"
    sha256 cellar: :any_skip_relocation, big_sur:        "229baf2ba65972abf6cdd15d49ccb6ff67e3917f0dc487acdfdf7df38a3a7caa"
    sha256 cellar: :any_skip_relocation, catalina:       "9beec17d0b2b75f2856d954c0850d39e2536eb696cf0df32173c016bcaffabfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1188f9cd6dee4728294177045367d356e2ba155fa857864242b19617b6eb9ab"
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
