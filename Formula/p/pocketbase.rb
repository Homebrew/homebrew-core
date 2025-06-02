class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "bb1d2cdc7316d62abf397aa6c3353c442a11b99f348b53e7e0b71495c2033ea6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb3a4b1f64b79a3fc2f7bce12c79c0f13d6db5685496630682346b86028c436f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb3a4b1f64b79a3fc2f7bce12c79c0f13d6db5685496630682346b86028c436f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb3a4b1f64b79a3fc2f7bce12c79c0f13d6db5685496630682346b86028c436f"
    sha256 cellar: :any_skip_relocation, sonoma:        "78e65b54c0dae6acb81f5675c89ec279085507cf655160791fd154291c83182f"
    sha256 cellar: :any_skip_relocation, ventura:       "78e65b54c0dae6acb81f5675c89ec279085507cf655160791fd154291c83182f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "104d6293bdb0ac33729263a3e58d15f89bec4adbcf713a197771b3f3eec1fd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffc67e9b7592a33fba1f8b17afe00de926d602231b02b7925eb5992d14893d49"
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
