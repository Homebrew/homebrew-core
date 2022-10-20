class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "97f53d67f8e8889a0c3793f7769e0a6374f65bef50fa02e54759bdb5d30c7ec2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be7c83ebd7a83d49efa06448a7d96ff8aeb5fb2484871cf4dab52adc5084b30b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53ba4f9c1c2ef16bf49a6a435cda01feef2a2f62ad62c3fd3597287b52bd9865"
    sha256 cellar: :any_skip_relocation, monterey:       "8a8ebce7c247cf0ac58dea705e1bb0e77e150c0a37d59fc0433729316a5869c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a3e0c551c85b5edefb9885b60d31c8afd4465a4764a81242218a10ae278fe37"
    sha256 cellar: :any_skip_relocation, catalina:       "7486c48d845f50f2953727289636a46f9f6b0dae43ccc7209c222d2c6e7e5684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f41572ba322d677e903f47bd5bc059691247ce936d9fb81248b33f928653787"
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
