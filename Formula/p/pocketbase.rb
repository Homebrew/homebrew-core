class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.9.tar.gz"
  sha256 "e75ee9a7f83d010d06d79db1669fd5ad40c454a81d497e14a131644ee1b48d6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a54c5c6875563880cfa26fd27d4b0bcb9350fc5d7b93ad2843eb45e05afa502b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a54c5c6875563880cfa26fd27d4b0bcb9350fc5d7b93ad2843eb45e05afa502b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a54c5c6875563880cfa26fd27d4b0bcb9350fc5d7b93ad2843eb45e05afa502b"
    sha256 cellar: :any_skip_relocation, sonoma:        "974ba31bcfaa16055b089d48403c55828114bbb6ac1bb8264f745ad8f3af1ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f55638a19c1eec73fb72ac8baa5bc0413d821367c10ae2895c4fa89deacdcb57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "414fe0247484e2a513ac959e81419e0aae56e4f223f45ada4d7c554a5eb0ae28"
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
