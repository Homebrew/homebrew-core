class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "97f53d67f8e8889a0c3793f7769e0a6374f65bef50fa02e54759bdb5d30c7ec2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ea6d4b78b5ee4c8b69af0b54a165fffcba84e571f59b0e29bf144bbf28f047"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ee1668df5e2987588d3c096c0434a65f30084dcb5999d332f17a52fb451869e"
    sha256 cellar: :any_skip_relocation, monterey:       "4c563386499b25e2691996f277b46ebfd03ee29ebea5e9b15ad0650d80fcd663"
    sha256 cellar: :any_skip_relocation, big_sur:        "7279cb0b9c74abe8d5221485f322009e4b871ad47e377ceeb6fea06e0e9b3a6a"
    sha256 cellar: :any_skip_relocation, catalina:       "6fb9f46aaee75dd89834c8ef3b8ae211f3f12ea9aced18d34a3ac4431b765fbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc06f6585ce4e0696e425dd9758b1ec8c70e62cd0056bb38a1d5c13e4eb01720"
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
