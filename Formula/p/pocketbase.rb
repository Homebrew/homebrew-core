class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "4b4cad231f5c61f14420a3542fa232655feca62ac4d3608878c4160a41c0d4b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f27ee4846e77de1a9d593c8a8788c4b8b15fe0ac9247c84fb36df5e48dbb55d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f27ee4846e77de1a9d593c8a8788c4b8b15fe0ac9247c84fb36df5e48dbb55d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f27ee4846e77de1a9d593c8a8788c4b8b15fe0ac9247c84fb36df5e48dbb55d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f27ee4846e77de1a9d593c8a8788c4b8b15fe0ac9247c84fb36df5e48dbb55d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "66a1a77b1e2b500ec3fff76f73a87cf27db8ff5d2e089c83a766d49b38fd0100"
    sha256 cellar: :any_skip_relocation, ventura:       "66a1a77b1e2b500ec3fff76f73a87cf27db8ff5d2e089c83a766d49b38fd0100"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4de577dd0751cefd9a69992522dddb83dbe29db583b491691b52ffff201f02b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd4996c0515003e4115ad88c2db89582c04b706708ca4df154caf6f9c43c8939"
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
