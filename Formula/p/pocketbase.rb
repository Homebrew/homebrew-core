class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ganigeorgiev.com/api/git/pocketbase/pocketbase/archive?rev=refs/tags/v0.42.0"
  sha256 "4ba2a3b66fc35d9ea28bda56a7da27e391f9aeb6b7296b2153a921bcd37081a0"
  license "MIT"

  livecheck do
    url "https://ganigeorgiev.com/api/git/pocketbase/pocketbase/refs"
    regex(%r{refs/tags/v?(\d+(?:\.\d+)+)"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6efa61e507ae66506060a79d819562b4e29acf210b1e7f9dc0287a845b23cd3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6efa61e507ae66506060a79d819562b4e29acf210b1e7f9dc0287a845b23cd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6efa61e507ae66506060a79d819562b4e29acf210b1e7f9dc0287a845b23cd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56c71026ccf79c77f204a0599d9d6e7b6e2e36081f6918de9166114d81abf605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c09c633a1e87b01a60bb868d532b8151224dcc7bcc6fb0faba1a96c27b947ff5"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-X ganigeorgiev.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
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
