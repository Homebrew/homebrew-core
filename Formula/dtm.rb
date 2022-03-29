class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "1dfd77af90441cd755f1fa0d97c304d99840fe52ab39b74631571387864c7eb8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b3924ee7dd47656a4774973b6cdfedc9b8a492cecf244286b9f071804d2cd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "075394c6076352c914fbbc263fd96796e9e5bbaf1c6e436ca18f2370a0232a2c"
    sha256 cellar: :any_skip_relocation, monterey:       "baed2a8d3acaecda1a8be92d36276150431a97422e1bed2eee7fbbf481a6c4a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d74b188a673308f6008a59a8e164262c84e4311056c160b28c0236de6d977e71"
    sha256 cellar: :any_skip_relocation, catalina:       "c681697a398ce50017bc4ea2074f44a7c8f2df8b3503643fe71b5a0cc34a88d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d6375ddf3a713ff9988f92370974037b9637be6469384093af5b171fc0b6319"
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
