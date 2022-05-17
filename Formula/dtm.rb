class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "32f27a65e705e0f9d3fba2081ed01f509aa425c2284024eea498bb331aa3e146"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e34115b9ff40993ac25604e332f434a9b86c749508d77bd7a641e1d537c0af0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5efef871566a70fe841af9bf066aada90f90a6062a09bfa994b2e11b24e6336"
    sha256 cellar: :any_skip_relocation, monterey:       "2fb799b8d68a49775fdf5e2767112a30be8ac667969b3b19510a9342c8401d0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "863d743b3fb3797ddf6ab53677bc975978491f5fc9c4532201d1a75bba298505"
    sha256 cellar: :any_skip_relocation, catalina:       "b68e1c189a43cde8d1f16e46363a98f4f68fd094b5ba1446c729bb7904ccca22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6991135f362aab35f0727901b8a965a80455957191e4dbd633ffc10096e7ee39"
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
