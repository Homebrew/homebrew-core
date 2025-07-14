class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.28.4.tar.gz"
  sha256 "87fa32132ce6674e0d89eb6140235f3d87f21c9a82289e703baa196c41829c20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85deaee01ecf35c3b037f57efd49396ee6c4f0f2a11e2d3326b7a0b2af691847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85deaee01ecf35c3b037f57efd49396ee6c4f0f2a11e2d3326b7a0b2af691847"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85deaee01ecf35c3b037f57efd49396ee6c4f0f2a11e2d3326b7a0b2af691847"
    sha256 cellar: :any_skip_relocation, sonoma:        "736a38c31c97486e21534428658d7e1a9879c3d5d810f64b8f26daea50b7207e"
    sha256 cellar: :any_skip_relocation, ventura:       "736a38c31c97486e21534428658d7e1a9879c3d5d810f64b8f26daea50b7207e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d13a346280142e9f91b871079cdbc8a98cdea61a5be04092185485820f243b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "453bbc4a7b8c8647f91646bacaedd839c624a322b2e605e51b477f49717814ac"
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
