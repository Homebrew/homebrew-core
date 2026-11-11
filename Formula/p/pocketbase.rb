class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ganigeorgiev.com/api/git/pocketbase/pocketbase/archive?rev=refs/tags/v0.42.0"
  sha256 "4ba2a3b66fc35d9ea28bda56a7da27e391f9aeb6b7296b2153a921bcd37081a0"
  license "MIT"

  livecheck do
    url "https://ganigeorgiev.com/api/git/pocketbase/pocketbase/refs"
    regex(%r{refs/tags/v?(\d+(?:\.\d+)+)"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1c2151affefbd76fad943da0c544a86e67fc09290ea392c75943a8c594409d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1c2151affefbd76fad943da0c544a86e67fc09290ea392c75943a8c594409d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1c2151affefbd76fad943da0c544a86e67fc09290ea392c75943a8c594409d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7cefd8a69d4cbc1b4d1d6a56a35b61adb8209faf6b3de29a90d1a2afc5c5c8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a9c63231d8afc186fe6128756da49b1aa5d7530fafcd1937b71d256ddf2c5bdb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-X ganigeorgiev.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
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
