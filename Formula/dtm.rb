class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.16.9.tar.gz"
  sha256 "afdd78cd28f619fae7e4e3d03f754b981d178592db0e55e171863b1ced16f405"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1bf08e852e05ca4f1ba595aaee0def298a3ae0374be3010c0c31dca4b3a4005"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de01147a4320416e124a4c9d5870244e7b444649615a8367bd2b2b7aefcd9067"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e27b22b425ab30c82f091280c7697e06bf6e233729f09694ccb29d849daea608"
    sha256 cellar: :any_skip_relocation, ventura:        "52c1d147b0374e219e97582f76fa6fa3c194e8e3be569ca7e5db30fa2d69c865"
    sha256 cellar: :any_skip_relocation, monterey:       "c1258d07a9c5f44359bd69c5c9dd8d03211cfd49b40bf53889342f47b119d93c"
    sha256 cellar: :any_skip_relocation, big_sur:        "56252e63a73171e30913eb88795e955492b025de3f7a86336a275a58d7f8780f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78c5195d2e5e59a7e4db203b16812fbbc2d6083ea12a73fcc760e8fa57ce5e6"
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
