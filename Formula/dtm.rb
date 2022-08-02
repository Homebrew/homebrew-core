class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "140824efc8ff659c2b1293e5557f71ee4d3332546962e315b6f323ee7326d47d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef3342c3d31fd2850feb51805fadec8b9874b3790fa4af17ba1503050d0a1be7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a699de2ce5ded3db23c95e9ebcfa922e4eaa6b500996fc9bcb70c18622c19efd"
    sha256 cellar: :any_skip_relocation, monterey:       "5fa4686528828f84e1cc82dd591c8259f90b093e5f329dfa254e117406793f3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e5c5e32cbb90de10d7ca98f1ca27ea8cacb14f31133e6f6fc9c40badd8907ec"
    sha256 cellar: :any_skip_relocation, catalina:       "6dc5a1a1ba82bf63cf8b3142c76508b583bb8c40501894ba65e257203cb54bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd1d243dd3734768efe3f111ef9f6027556266c1b68f35569ca4795de5fa4501"
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
