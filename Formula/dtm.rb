class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "bd21e50e09d816d33501233ee37fd9ee4e1fa33b8ff08f1bfe07bc0f903042ea"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4432b1961981934a4187779f7b1d3caf399a02e4bdff88e550f4a84f7cec5d14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b81b5d284164d5875b9dc16c0ae06194f686d495f6116f73d69bcb5583ee53c"
    sha256 cellar: :any_skip_relocation, monterey:       "89e07aaa2b3000fd3b169e51eb818abca54e60dc299ce51218988e099ba92f0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a931f14a31f4fb6ceeffa950e38a42d5d91edaf87a7fd623babb87493e121fdb"
    sha256 cellar: :any_skip_relocation, catalina:       "47ef34fcee78cdd15354bcbfbd1f71b030d531df5190af6e9bce7e371f169fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7228ae4cfc2ba79f40e213212c69a9ad31e498dd73017365271bd7e952e1991"
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
