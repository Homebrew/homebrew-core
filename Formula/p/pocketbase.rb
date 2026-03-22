class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.36.7.tar.gz"
  sha256 "10fec6613a3aa63ddd41a6ec1cfe4200f73d5c6038fd7396b3a7965bcc87a260"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "374cfc38495e4230b3fe9cd35e3ef74619e9122c5ed039da0a524996172b71e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "374cfc38495e4230b3fe9cd35e3ef74619e9122c5ed039da0a524996172b71e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "374cfc38495e4230b3fe9cd35e3ef74619e9122c5ed039da0a524996172b71e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d68af7e6a265e5cc7308f68f207beee0ac4bbdb0a615c186e676f724265e4dfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f99ce3d442a377d67914f094526a2405edeaa360717c99267d0132d329f583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29013c2a1bdba1a0f49ad28480592f8adc3f964659508ea6df6fb7d96a9b7810"
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
