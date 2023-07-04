class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.7.tar.gz"
  sha256 "18a802bbed4b056203ac755671a71a150bab7060357b08265a9625dfebc639ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "328259e0f2b12d578ec41dbb04f8f3d69bd18fce88b3a72a6e9f3241e72a32bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "328259e0f2b12d578ec41dbb04f8f3d69bd18fce88b3a72a6e9f3241e72a32bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "328259e0f2b12d578ec41dbb04f8f3d69bd18fce88b3a72a6e9f3241e72a32bb"
    sha256 cellar: :any_skip_relocation, ventura:        "646ef994992b2e73da4931f272a6b895c39b9177c658d6c6e56f24ee7a0dc94a"
    sha256 cellar: :any_skip_relocation, monterey:       "646ef994992b2e73da4931f272a6b895c39b9177c658d6c6e56f24ee7a0dc94a"
    sha256 cellar: :any_skip_relocation, big_sur:        "646ef994992b2e73da4931f272a6b895c39b9177c658d6c6e56f24ee7a0dc94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36052f6dd1309236c60236c92ef1bc0b1eb260f3dd6ac2209c9658a4e4a7b8d9"
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
