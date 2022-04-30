class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "322dcbc08bd2b73e2a6d709f41e6f585de605a05f8efcc1c2b98f1a35bb04134"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2abbb155c15ca6d10058052f8502f5a480f7e3de06a65c1837786aef55b5668b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "771cfd36965b5762e75e54de125f79008d9b8dc47101e91d6c8b4c867417fac0"
    sha256 cellar: :any_skip_relocation, monterey:       "828576d040e9959713e7d193f263a2090f77921a1040d67fda88bd2d8f6c5341"
    sha256 cellar: :any_skip_relocation, big_sur:        "30a6a6be198d2d25c9650408642878ae5df6e260c713a05d2e422d66a664a63a"
    sha256 cellar: :any_skip_relocation, catalina:       "6e9a9ddf357c5629c8ca052fc8c4c479d0ea14060641f84309bccc8c06fcb806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9dfef4fd43718e1f9f392e08a6ac1ca8b97cb31b92d05338afc76a6bb64cd97"
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
