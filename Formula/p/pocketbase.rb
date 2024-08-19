class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.19.tar.gz"
  sha256 "4b29c1c63cab2c57ceb129c323fc882c5809ce0949f1fe9a7cca29dddc6da210"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "def5458142ec83fe88140f17b3f5fb5aec3f1b7106f6c65f1726ef6d369e3eac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "def5458142ec83fe88140f17b3f5fb5aec3f1b7106f6c65f1726ef6d369e3eac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "def5458142ec83fe88140f17b3f5fb5aec3f1b7106f6c65f1726ef6d369e3eac"
    sha256 cellar: :any_skip_relocation, sonoma:         "49f44e86c12779fad070453bebd01f9c74541f70e2e9bb424f09091919a4d069"
    sha256 cellar: :any_skip_relocation, ventura:        "49f44e86c12779fad070453bebd01f9c74541f70e2e9bb424f09091919a4d069"
    sha256 cellar: :any_skip_relocation, monterey:       "49f44e86c12779fad070453bebd01f9c74541f70e2e9bb424f09091919a4d069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d48a817fcf0fd4c968d12738e34c55ab7e75a370f8e165439661d82d918cdc96"
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
    Process.kill "SIGINT", pid

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end
