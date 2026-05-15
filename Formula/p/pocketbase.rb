class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "de20714bc234c86857f8a7fd15240cd027e221450008d49a9cc4d58185e635e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11cf2c3a0a091a4775dc4bcfa0208477557bd518a2080f971431b2812c0eb9b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11cf2c3a0a091a4775dc4bcfa0208477557bd518a2080f971431b2812c0eb9b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11cf2c3a0a091a4775dc4bcfa0208477557bd518a2080f971431b2812c0eb9b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5197f76385a93df9cb7cc32c1b913a64d90e5cddad9e9c9a5e84cf07f7201f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d03c48abec58afac3576525165031f2f5b000e69dab510e326364949e7dbf9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5274806af17d5b3649fc856a8929b2cd39cbddf02e64a0330cb0cbe8a3c32b1"
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
