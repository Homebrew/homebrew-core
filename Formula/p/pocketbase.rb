class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.26.6.tar.gz"
  sha256 "1b2294986abc8c4cb9554650b7809f9e5fd7c61f3b24ecc011dbb48dc31bd162"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9becd680737c6bd08aaf07222c3c8617ead4637d85125b3d3d89492f9d050ff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9becd680737c6bd08aaf07222c3c8617ead4637d85125b3d3d89492f9d050ff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9becd680737c6bd08aaf07222c3c8617ead4637d85125b3d3d89492f9d050ff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b59f3c881232fc72585bb4185bcbb3dbeb60b682e9e55ca9642b4fd6e732c1e8"
    sha256 cellar: :any_skip_relocation, ventura:       "b59f3c881232fc72585bb4185bcbb3dbeb60b682e9e55ca9642b4fd6e732c1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d19dbe20005227cf09da399508146265ddda9c69663959b6e7e3efc8fba7bc8e"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port

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
