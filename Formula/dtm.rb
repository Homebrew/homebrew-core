class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "b35c83a28f88201d9e13c84496dd467f7caceb9eb7bd71f8dcba23e65d652c00"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a206b975482b18c7376807aba82f80ad0f64409ea4cf0e46468bade0b5fd349b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d96fe7286f482f0756d91735f73d2b6a8d2c64bc6fd8b88cc06024a6e55ee5a"
    sha256 cellar: :any_skip_relocation, monterey:       "dfaebbe04ce4fffbe0af06743e3f8efccf609734b739df47b6a579c369bbe50f"
    sha256 cellar: :any_skip_relocation, big_sur:        "20e1b04c8610fe2efaec8e3a38b48445d979b58387d47eca295c60aadbe0e826"
    sha256 cellar: :any_skip_relocation, catalina:       "f32bbc95e08740cea3c9f82c393483685dcd85e0255fae340c46d9d38cfe9264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efe3a7da589c3d08914a1ccfd5d2e0d62cfbf8514df5190917767f2c3b7bb7fe"
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
