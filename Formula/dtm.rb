class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "06b95847dd619404e5171f410a922724d7d654ab0bb4c70681cb3ae510db11c5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "729cd98ae7c42ad49d9d5daa00cd56dbf70d3613a62b6b84ec4447bca02fc1ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "771c065bf50281e057521612c7d8d22cb3cff008ac466247f1186f707bda2e82"
    sha256 cellar: :any_skip_relocation, monterey:       "56cfc82b995c010b2e0cde832b4b924c29fdc38c91e24e5721ecfd2f9bf38198"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cb837798da7242fe4b174c72dae9d7ea677ea049ea9280c166e6bb82dc36d91"
    sha256 cellar: :any_skip_relocation, catalina:       "d4092767b0efaa726cea2c92b9193100e916205ec8a61b2f1b36f80c6fbf7292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b90d306bb797dcb87bbc7a916c88117eacec752ce673e68d9d76e5ee7f4c42ab"
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
