class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "11340c32e810dfd463953bca0a5f5a2c41a88c35782efc2ab70cfa78733fa823"
  license "BSD-3-Clause"
  head "https://github.com/dtm-labs/dtm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9156f67d4bcb54b15e9ee5b1046c4fd71fed0f1e2770c326f158a519384b7bf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "818718052e97df9ffcfed8c29a8f7bbce0e5302c6639c208c3c080d188ce75c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "818718052e97df9ffcfed8c29a8f7bbce0e5302c6639c208c3c080d188ce75c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "818718052e97df9ffcfed8c29a8f7bbce0e5302c6639c208c3c080d188ce75c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb8953792e5ca9d7edd4f56547f3f333ff6bb34de276f60781edd57acedc1288"
    sha256 cellar: :any_skip_relocation, ventura:       "cb8953792e5ca9d7edd4f56547f3f333ff6bb34de276f60781edd57acedc1288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31c5da9b3ef4d90e2612b6b0141f4b105a4e641d595bde14df75647726498cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2def5327f55d8f789fa34bbe6ad73606bbe2807d42a59026f04130456fac0cb"
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
