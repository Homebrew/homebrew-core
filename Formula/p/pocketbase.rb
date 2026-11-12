class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ganigeorgiev.com/api/git/pocketbase/pocketbase/archive?rev=refs/tags/v0.42.2"
  sha256 "836596f0e4ad0d2fcae5a7fb71eca6cf90e034be27c6ed9c4c89179c7b64c8b2"
  license "MIT"

  livecheck do
    url "https://ganigeorgiev.com/api/git/pocketbase/pocketbase/refs"
    regex(%r{refs/tags/v?(\d+(?:\.\d+)+)"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f224be772cde85ff804f6a7675c2b044d9c178574c416564914c4083106a1187"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f224be772cde85ff804f6a7675c2b044d9c178574c416564914c4083106a1187"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f224be772cde85ff804f6a7675c2b044d9c178574c416564914c4083106a1187"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21015284ea47ee2c922216d1c2425d3e0468d3c4e0bc3b9fa89d0226ba761f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1975fbd8934cbb724c4b5d5da0f948d7b1a1993eaaad9392ba4bfce946ce68ba"
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
