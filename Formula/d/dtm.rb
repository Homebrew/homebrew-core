class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.17.5.tar.gz"
  sha256 "26d2d63f901b2fcccab6cee427299730d71bed76e88a081c2f62455375a7a0d3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff87fce08bcade7df5311fcf3f1cb9ba458224d95953ed3186fba74a2d8ba800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d46d32e25a716a50023acd5364498ad1e6b0610f4de8a7c8e018148a6f28ee96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6653fa440adfd7a243a8c840d36fc1e91ec419b0fe0c8326eb6158a65c356b2f"
    sha256 cellar: :any_skip_relocation, ventura:        "44e85fa8e4cf7a3ffcd2d990e58a323a8f7ab5de7b87589293072d29b22dd01a"
    sha256 cellar: :any_skip_relocation, monterey:       "5507ab53c28a4a2be0382303b5508ceaedf819b17783e802391e9debbfa38d35"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cdf652c63b4eafc63fcc63b39f6b04b8faf93de6dd175e26424e58e42570c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fd058b646a6a7bdecf04123b880d4db3155ae8cdebf271b35997482e730c60b"
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
