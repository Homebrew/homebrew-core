class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "5150686ca4d4dcecfd53f714b32efe0b57870a28868e43de5797383dd1dff04b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bf57948be27eaf6842d1e8a07326fa9b61596fa1a33746ce181b105b013007a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bf57948be27eaf6842d1e8a07326fa9b61596fa1a33746ce181b105b013007a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bf57948be27eaf6842d1e8a07326fa9b61596fa1a33746ce181b105b013007a"
    sha256 cellar: :any_skip_relocation, sonoma:        "919740032ce21b7956796bb9307fda73a68d8cc5cabd584a840c05a9758b428c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec150c605c731bd28b66fbe5eb9f4dea50197c9442c4c0a7d9887f596a8ff40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef99a1a36a8bf9a5053060d776afc3c861ac8cbaf626f0640814c3f32b6a77a1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
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
