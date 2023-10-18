class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.17.7.tar.gz"
  sha256 "b9c3d8f9d3c12a69f87ac636ea25cc0526fbdb1d05f902e9225f7dc2a736d8af"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fee23dcabd3dc58cfa6fbb49fd96675a2750dd7a987da808a1f30777fb293142"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f06027c3b706cbc60c18fd2c111d846f17fec2b02467e4f5cfa9cd4c278e88d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea3347836643f328deb1b1d06d17d7f6247f1ab3be526fcdeed9621026403021"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbfbb553116f5218510b01470dc55546d4b06e13234c97f512c36c9af992837d"
    sha256 cellar: :any_skip_relocation, ventura:        "e3850b6a6685b944757939b6670cd085364f54fc6f4c52e445fe02cf159e2edb"
    sha256 cellar: :any_skip_relocation, monterey:       "3ef2e86484dcd6b66017e3711d9fa1d9134d0dac42c87017d7bdaea2fcd4c3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56769661afb1b888515b30a321659998aec78226bc51e181c622dec7fe3cf859"
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
