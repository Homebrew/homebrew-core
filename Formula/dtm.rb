class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "67a6c145ac548529f93712fd252df8e7df964e01f8c12d97e136eb4b22015d42"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5aff5e092db5c45af955ef087ab4b12c47519028f44a880a67d6e078e46f50a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bdbe1db02f7dd4fd83e55af29ebf47e7cd4cbbe1f5852037ddfe4ac3b834c6c"
    sha256 cellar: :any_skip_relocation, monterey:       "1d9be7d83a90e615a4ee2822390a324d4400accab859fc1813abbeb38c5e3885"
    sha256 cellar: :any_skip_relocation, big_sur:        "a472991d8cb2fc8c04d1bba87f5f5cf5cc6af650374f04e9df47aff09aafa0e1"
    sha256 cellar: :any_skip_relocation, catalina:       "b3a931c27b617530f4e4bbc729101b3d834c6b6f9639e6e23dfa05f6bcae78c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e8760fdc710d739ba7886027af76be7f7226c3b740ee2c0ae5f678ecb0e60bb"
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
