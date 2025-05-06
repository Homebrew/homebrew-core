class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "686998d1e4414eedff77034441e2a78143f21688dc0f4df1e09b8580e4a45df7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b37f8644a3586102998890c0a50e103a8eb50354dfc4297dd09f250ff438d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26b37f8644a3586102998890c0a50e103a8eb50354dfc4297dd09f250ff438d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26b37f8644a3586102998890c0a50e103a8eb50354dfc4297dd09f250ff438d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba654fc044c8dd16577bd42a9d537b53a8738b51166d5379f85c346fdf75246f"
    sha256 cellar: :any_skip_relocation, ventura:       "ba654fc044c8dd16577bd42a9d537b53a8738b51166d5379f85c346fdf75246f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "627b843857a2a3e22cad9e7a53bdc9a0571491cde1fb9987595e4c84d32bf1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c32163324ea57aba62de1ef72d3a022411285fb3388c9bf2a193f3852d3e3b"
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
