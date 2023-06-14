class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "0a93a782d97f5d5086d3ec2f22481cdc16bd8b671301ce642a0fca4c74cc28be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e78a25a8a787404754f9b17625b2aa7cb291eb6f78ac5603cf8ac0594fb7e02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e78a25a8a787404754f9b17625b2aa7cb291eb6f78ac5603cf8ac0594fb7e02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e78a25a8a787404754f9b17625b2aa7cb291eb6f78ac5603cf8ac0594fb7e02"
    sha256 cellar: :any_skip_relocation, ventura:        "6e61022ad60ba44c0874c1330277d26a3edf1d5ff74f039400a92d7765f08583"
    sha256 cellar: :any_skip_relocation, monterey:       "6e61022ad60ba44c0874c1330277d26a3edf1d5ff74f039400a92d7765f08583"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e61022ad60ba44c0874c1330277d26a3edf1d5ff74f039400a92d7765f08583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ef25bba6163cd93c5522830c439c4d76ee7631c02084ab1edf373836d8f9c9"
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
