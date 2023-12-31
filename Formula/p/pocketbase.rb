class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "6fd7605d7f75eccc17546d00b78c6fefd03010fdde5b28141becbeed3242f9bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1583d3f2326ace2737a8b0eebb0b5634655328a8d9a4023f7c4fce0fda1740ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1583d3f2326ace2737a8b0eebb0b5634655328a8d9a4023f7c4fce0fda1740ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1583d3f2326ace2737a8b0eebb0b5634655328a8d9a4023f7c4fce0fda1740ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "076b7ddae2b45f7ca58e1a8b551b6ee1b85aea44347b7d89f8ee661ab53bd16a"
    sha256 cellar: :any_skip_relocation, ventura:        "076b7ddae2b45f7ca58e1a8b551b6ee1b85aea44347b7d89f8ee661ab53bd16a"
    sha256 cellar: :any_skip_relocation, monterey:       "076b7ddae2b45f7ca58e1a8b551b6ee1b85aea44347b7d89f8ee661ab53bd16a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cf9ed415a3ad75dd086d26304d2c3eda5443a6de3f5cb3316f3df9228ba6081"
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
