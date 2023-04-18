class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "d880236b4016bd6500056ea628ec3773ef265d15ef18aa563800ab398db2bf74"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aea956c3da68cde5b77068f31b98c1b7e4a2ccd19412f0ef68b8588b44ab549e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aea956c3da68cde5b77068f31b98c1b7e4a2ccd19412f0ef68b8588b44ab549e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aea956c3da68cde5b77068f31b98c1b7e4a2ccd19412f0ef68b8588b44ab549e"
    sha256 cellar: :any_skip_relocation, ventura:        "921753dee928e8c1f27168897f467c45ab2b3459d017da0b153ab8e136332f81"
    sha256 cellar: :any_skip_relocation, monterey:       "921753dee928e8c1f27168897f467c45ab2b3459d017da0b153ab8e136332f81"
    sha256 cellar: :any_skip_relocation, big_sur:        "921753dee928e8c1f27168897f467c45ab2b3459d017da0b153ab8e136332f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fef834b183d5b4fe9139587bff27614c8887ffabba770d9131fcbb4fb7d4615"
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
