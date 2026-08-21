class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.11.tar.gz"
  sha256 "4923a08b91a67fed26b5936a11abc2007226f027aa863172a4b9de2ada26e954"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d1e22a3f9eba7ab087b2e54c74ae3899359b1434e930b355ff49272e0892d8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d1e22a3f9eba7ab087b2e54c74ae3899359b1434e930b355ff49272e0892d8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d1e22a3f9eba7ab087b2e54c74ae3899359b1434e930b355ff49272e0892d8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d5005333339676be1243363d61f23460cf5753d70c3855a6db7624bac0e763b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15853e7171e909bf53459050848acdad1b959555a860967a81e936070c20b836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "770cd8d9d179117dec8db8adc153479bf75da48c6d3caf4c7aa67f4e065a6b24"
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
