class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "ced6ce12f723d637c8f0b74c077f83958cef9fab589c7cecf3d62a72b8aafc19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f8dcf65ea151d7d368d77fb1ab7842c969469f61cc325d641c249e80bb11286"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f8dcf65ea151d7d368d77fb1ab7842c969469f61cc325d641c249e80bb11286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f8dcf65ea151d7d368d77fb1ab7842c969469f61cc325d641c249e80bb11286"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c922adebabad0d8cf1f33ece6244b987102349f44d965c1b5ff3592249ce128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c9abf211759395b609f9a8871ffbc726af0227158f678c90b52ecb51c95f51b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85b0471500da34d3e83f4b4e1d76d81a4ce22a0e4f0c801d9045e28092e38eca"
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
