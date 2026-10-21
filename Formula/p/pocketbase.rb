class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.40.5.tar.gz"
  sha256 "daed8aa7ad904054b6d983f9e4ede95fafdb27594813987baa2e6a566a177dda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "befdd2c63e7ef5510370b32db78eeb99a93226f07d886c6b164a63a1a8625ac4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "befdd2c63e7ef5510370b32db78eeb99a93226f07d886c6b164a63a1a8625ac4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "befdd2c63e7ef5510370b32db78eeb99a93226f07d886c6b164a63a1a8625ac4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa42469f2d8adac16bd79087e8d924cce91cb8025409b28ec58201ca9ad28936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a354587ece6bccf1ee53bc097e4fb2e9eb65dfba89dd7f4adfbcb6bd8406ef8b"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
