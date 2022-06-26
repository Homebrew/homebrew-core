class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "94c53132d6b3679c643178f9db66922f6441e81e8a03094ff95be6bc8bce3cac"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea5e1d23e08371917dcf44b140263e262c12d3d6a25251161f9f544afae0b039"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2861f0800c9895d95a569f5f1691c98a3d8b7dd0e1cd77df6f03fc74ccf0f8d"
    sha256 cellar: :any_skip_relocation, monterey:       "c530422c825601fa541b4666565d91d2ddd2f3a328d4cb48e8521d2260bf9e44"
    sha256 cellar: :any_skip_relocation, big_sur:        "03725db3cea1d0bdb3802045b2ae9d8abfe030ba44555c56cfc113565ad23b5f"
    sha256 cellar: :any_skip_relocation, catalina:       "c4d04a3f8d93e3b5072c95c9dd1346e4193e9ca375f44423f7e5ed2332e72188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9df5669005b45a2b11c602c236146bf6656ae60c7992124e8e21d218e151ce27"
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
