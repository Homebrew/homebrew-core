class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "ae65afcd77d10ace558042d4611ec37a264500cfdb66f94f54a2f429ab93ba1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac13d34711304271d1080d9a7e4da582bc41192449747a17cb77203d82cd1a38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac13d34711304271d1080d9a7e4da582bc41192449747a17cb77203d82cd1a38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac13d34711304271d1080d9a7e4da582bc41192449747a17cb77203d82cd1a38"
    sha256 cellar: :any_skip_relocation, sonoma:        "f042493bc5ca702f1f4f1efdbc9551fcfb5067125f651081ce3614bb2adcb7b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73e7eaae4f1b37b09eb6e89b59bb3605227920dad18fe9f6aea740bb2aae7397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "990bf1981ae33fd8f89d4df4b8600bc195b5d5197d7f39ced406a711bb296e78"
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
