class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.2.tar.gz"
  sha256 "7d275ea218f058282deb662d0c0f0dd0a6fd460199294262c469f4e0e42ba843"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63c1487e5e8565672111c5a94a2937921f5ae484ba176ebd74b5e8448cb687e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63c1487e5e8565672111c5a94a2937921f5ae484ba176ebd74b5e8448cb687e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63c1487e5e8565672111c5a94a2937921f5ae484ba176ebd74b5e8448cb687e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "be4f16f77da93577332bd759954c3d4996a592c7e2c4c9355b222b23ac48bb86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7ca233fe6bbc757a9fad474583e0f3a3dc0a3f1a4c511867ab41be0c63e0079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9486358f54be6979e633a7ba6c43e15e7fc16cc6f5cb5867d84280a0a453061"
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
