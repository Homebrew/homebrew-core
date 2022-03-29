class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "1dfd77af90441cd755f1fa0d97c304d99840fe52ab39b74631571387864c7eb8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fb4fb6eca6a5ce0c855d27fc6a1c87b2fb6f2ba1a99b10ebe757d4dcc88e2ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "790f36bc2762fcab724fc0179dd4f10a7fab11584fd41aa4b76c3e1dbfbe73c4"
    sha256 cellar: :any_skip_relocation, monterey:       "abace59708c3796d06e437c81e4ea673c8a332869604ec68cdd28350b43a8431"
    sha256 cellar: :any_skip_relocation, big_sur:        "51d1c095efa6a10d6253edb663be8a3f379ab1b2424b654c9d2edbe949428110"
    sha256 cellar: :any_skip_relocation, catalina:       "d877a89483e099f2c04c7dc6644ac8bfaece4174846d07b0b341cd166a728204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81ed0f1e6de8853bfe77806fd0b7e770943cc6058e765d43d24f7402135246d6"
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
