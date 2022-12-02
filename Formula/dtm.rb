class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "d9b6fa694c506c6b17ee221698ee25e6360555cfd8737483154cedbbdc7cc7b1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af3f91e28a8344c7b9bf2eac8bd858d94538dd6d80f9ab5e3bfeb0851e56cc00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27b4666fd34d6a552f359045f39c3ae6511e4a196333cb7a7080e9a294878326"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d14a5f62ea4f2f51352635d626b15e3a19ce5faafd768349be3a88c4f650df5e"
    sha256 cellar: :any_skip_relocation, ventura:        "944aaa181a4f0cde65f9bfd5ee70fe343a0bd1bf7109a483dbc3e61b262524fe"
    sha256 cellar: :any_skip_relocation, monterey:       "c23fcbf0fe2f22f25940b8a773a33e41b015e2e2664275544233f4fa690e449b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5375a92a34d64d21589921ac057edb45da4364380416cf210eda785646e5cbf"
    sha256 cellar: :any_skip_relocation, catalina:       "af03a87c69ed3a24c15f2cd67c1fbb264da538f31b8400bb6f1a2fa441a3d284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59abd9fda346d6af2904ace3eafa7486b0be5a5006d50e21a1602a07e26dc87a"
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
