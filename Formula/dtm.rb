class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "94c53132d6b3679c643178f9db66922f6441e81e8a03094ff95be6bc8bce3cac"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c830c0ce4e53682a40097aaf0e4cb6e78c39e2268690c10d429f5f87ad74a5af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86e3aae7a5b757beae66c89f28912342684c519b1a0948facef3ca36ad12b057"
    sha256 cellar: :any_skip_relocation, monterey:       "9def2f28aaf9de83f8286626800cef2d5cfe51747201e7adcb2d75ae38dc0664"
    sha256 cellar: :any_skip_relocation, big_sur:        "dda748c817f99ddc82c31ce656c5a0f8c1a0375aed378e0cda755ec54e24f9c0"
    sha256 cellar: :any_skip_relocation, catalina:       "0f17be676b6e6bfc273a71b1890c480291033ef0d7f1d3246a76167cd54d440b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "563039c5d461155167b074780c7645848f8d57f613c2ad98f0d3fe9919bffa64"
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
