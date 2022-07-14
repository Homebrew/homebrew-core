class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "40ff9a5ad1b5f85f1dc96e71cf54cc4b2d49641f5cd879304cf2aa19345aa523"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3992499d12586fd07829e3a817e7cb6a4d8cfc52180291783c8828178ede209"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "991647adfeb6a574fa729563c32dc841b53add862b3b6ed1133dff6f692a978c"
    sha256 cellar: :any_skip_relocation, monterey:       "66a70577e40e1c3a47bf090837a7220c027fb04a655d6c990b37009da0181a45"
    sha256 cellar: :any_skip_relocation, big_sur:        "388f759f64cae727e32d9baa069737e84806f7a5e71d06cad8905357b905651c"
    sha256 cellar: :any_skip_relocation, catalina:       "e12f3c8f95b607420e1b722e1ee8e51249ba0545897cdd381891790b72ed99c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae44759abcf1e5f3277720e78f6d7a4065042af734567d1030d47d193753ec00"
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
