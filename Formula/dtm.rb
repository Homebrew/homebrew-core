class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "8de9adc52558c1913ceb5af550870716ee8125aeded182187a11e44df1089752"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcd7c72681942404d99af33dec75e10d9eecca8ca4a8bc5215339f99802771c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9be803bb1c2da1d4d5f90e926836dc0cecbd122ee974d0d3c0e9e7f18776571"
    sha256 cellar: :any_skip_relocation, monterey:       "c648a1a92686c3a3ff7ec5ffa43edb105ceaddcbcb0c4c7d6e7061c88beb1db0"
    sha256 cellar: :any_skip_relocation, big_sur:        "925d57d3a73cfe4f46a790b393950ce36ad3084eb7d62a8304ce4a24a535fd3c"
    sha256 cellar: :any_skip_relocation, catalina:       "7b0079df59c96847a25b50d4a0619228c3b346990ead8fab975b9400e85bfe42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76885d71156b821f63e562e9163dd38d806f7c2885efc110f0c2a0865daee650"
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
