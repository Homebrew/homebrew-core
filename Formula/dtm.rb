class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "0196b68c9acabb7a34ff9885b8da863e19ccea99cc278f4a8619f5b75befee7e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "932bb3f3b66442a40b2de82b2f4010edd19fe2e72cc9f4adf6803967b78bec88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6227f03cdba58636703a44f66efe4734785df85d013f15ce1c501e97adf37f60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "457ed8232961f33204ddcdbf34a99edd0bdea10c51d65279c79adb5ea101ded0"
    sha256 cellar: :any_skip_relocation, ventura:        "34c259d7a78ea416551efccf889149ccb9c52b7ac3e40a56e0971396e1ac7588"
    sha256 cellar: :any_skip_relocation, monterey:       "6a202bca5b8f49c89806f0da101d942efad9fe645800b8b07115559e07db559a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f6742e5d26627a64b9952cd3eb28e3d9d0cc471c5d8897996fa51d7156ff16a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d882f616e0cc4b0c30c44f80d75d48af0130d003a29d853e9e2a8e74ebb961c3"
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
