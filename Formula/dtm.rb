class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "d5dff43d9c8fc784525cd1450747ee141d066e552034575c6219d982756e0651"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "645c5356dac0fb10f9cf4860c9e40bd42dfcfbe7e4793ebdeae7b9f94f736ae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "018984dc6cc8e9240b514eeb07f28eff9c66e60b8c896b88e5bead3728c88016"
    sha256 cellar: :any_skip_relocation, monterey:       "b2c3b93062b544cdec5661b5453358e8aabf0c2246738c9989c3e7be77d109a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fc6b79ba67a7c3b2be9ab5fc23d3c05da1dbd41d2dad8cc288f43536398b566"
    sha256 cellar: :any_skip_relocation, catalina:       "85af76fff7f55e79ff81376e77d364be1c1a31a3995438c796011ee90396de2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e1db6852d1c7f3d9d39337305520601caaae371f8e8242f997519b947585a1b"
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
