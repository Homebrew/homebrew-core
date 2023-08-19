class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "07e5aba2b90e94d280700f1257cfcfc9850c15e69f3632c951d83b190147700a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0833a7087d8c13f59ef3a5e766b3a0f85d30ce6f87fbbbea86a7c094656a1c99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0833a7087d8c13f59ef3a5e766b3a0f85d30ce6f87fbbbea86a7c094656a1c99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0833a7087d8c13f59ef3a5e766b3a0f85d30ce6f87fbbbea86a7c094656a1c99"
    sha256 cellar: :any_skip_relocation, ventura:        "261798c44d73d1afd07ef77332ac69cf27a1ac614635b0e6d3ad345a0af4a7e3"
    sha256 cellar: :any_skip_relocation, monterey:       "261798c44d73d1afd07ef77332ac69cf27a1ac614635b0e6d3ad345a0af4a7e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "261798c44d73d1afd07ef77332ac69cf27a1ac614635b0e6d3ad345a0af4a7e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4326d257de2ddc8dedbedb3b7413c3c2586c1709dd4e527b9392e3b46ad92a2f"
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
