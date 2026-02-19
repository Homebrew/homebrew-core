class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.36.4.tar.gz"
  sha256 "085b6ae121f529714e16c7d4e3a840fc6e1f622ae109ce9ad108921ece0146bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ab2b5dcaef5cbc650a5c74ba87f3b81cd62a9b084c9f9d816918080b30b71d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ab2b5dcaef5cbc650a5c74ba87f3b81cd62a9b084c9f9d816918080b30b71d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ab2b5dcaef5cbc650a5c74ba87f3b81cd62a9b084c9f9d816918080b30b71d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3d0053a8f04f8a3fab694b843e0815aec75f61b9ebb736b072fa9b81abb5aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "121352793e31eb33987500717d0612fb9b32c36816759f29aeedef926f9a5b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a701faafc020fb918137096cbe59501d5aeb4ae2e4000e40f9b58342180c0c97"
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
