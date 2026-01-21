class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "81330fb789e58b74e3f732fa6953b99e78d1dfc518a41965e6c282cfa8d62c63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "687c199406cf75f0266fc81457cb28ae24782945d554ca03de98f3bcf23ede37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "687c199406cf75f0266fc81457cb28ae24782945d554ca03de98f3bcf23ede37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "687c199406cf75f0266fc81457cb28ae24782945d554ca03de98f3bcf23ede37"
    sha256 cellar: :any_skip_relocation, sonoma:        "0369eb291da3330d3e208401d4a8219344e4b479e24513e529188df72fef3620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94c69499c429ec87bf78be4a31eacccb186b33ad1fec90395ecaf7fd79c9b235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9014368b2695ec3169bde2175d63d8dcdb6fb81320a58612ec76478864ef9c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}") do |_, _, pid|
      sleep 5

      assert_match "API is healthy", shell_output("curl -s http://localhost:#{port}/api/health")

      assert_path_exists testpath/"pb_data", "pb_data directory should exist"
      assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

      assert_path_exists testpath/"pb_data/data.db", "pb_data/data.db should exist"
      assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

      assert_path_exists testpath/"pb_data/auxiliary.db", "pb_data/auxiliary.db should exist"
      assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
    ensure
      Process.kill "TERM", pid
    end
  end
end
