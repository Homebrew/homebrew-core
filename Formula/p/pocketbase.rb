class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "b948ce228faea5e5a5f7dff3f0eb733b3c26aeb12c3389562942712f424cc30c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fbc61111be8dcbac58746bc648e978ad1f16657dd01b880005a939dc420325f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fbc61111be8dcbac58746bc648e978ad1f16657dd01b880005a939dc420325f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fbc61111be8dcbac58746bc648e978ad1f16657dd01b880005a939dc420325f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e48c628d505e3b67356d8ecad442c9349ee96d6c5a6e20e59f47321d2a0f986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38396f6d1516dc7c38dcc5afaca2b71d76e832992fd9102888e5e93943a459fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dde87080c0e04b9ebcce201550d8b5d29788f13f240b9deb79f37125606035d"
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
