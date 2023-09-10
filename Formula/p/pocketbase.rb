class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "3c56099d0bcad0a052eaa15a3b6737a81f9461b4d1c429b0dd00ab8bf4564981"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7d7f27d0ba8177944761ff4a4a5ec2784bd991c8b24040837ff6eca1c794f25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d7f27d0ba8177944761ff4a4a5ec2784bd991c8b24040837ff6eca1c794f25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7d7f27d0ba8177944761ff4a4a5ec2784bd991c8b24040837ff6eca1c794f25"
    sha256 cellar: :any_skip_relocation, ventura:        "f3a04fbf3563d5a1bc85c4d63c202f9f469e270f115a1d3a6d8589ad1e7ff667"
    sha256 cellar: :any_skip_relocation, monterey:       "f3a04fbf3563d5a1bc85c4d63c202f9f469e270f115a1d3a6d8589ad1e7ff667"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3a04fbf3563d5a1bc85c4d63c202f9f469e270f115a1d3a6d8589ad1e7ff667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "973c23f93d21b703488ad4cb24093dbf8a18241226185ecd52c5fe0be442f09f"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
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
