class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.17.5.tar.gz"
  sha256 "357735791055e8d88539ce143760133504e40135eec962e1997fc04f985fb7a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8101879a0d79e48d6168c406c77638f581c094a96fc2c202a5560e5354cd9d23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8101879a0d79e48d6168c406c77638f581c094a96fc2c202a5560e5354cd9d23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8101879a0d79e48d6168c406c77638f581c094a96fc2c202a5560e5354cd9d23"
    sha256 cellar: :any_skip_relocation, ventura:        "f6855ca8e76e0da6d6e85816c2e66d0d3c16f48e119e5c2b7dc4f728e76c008e"
    sha256 cellar: :any_skip_relocation, monterey:       "f6855ca8e76e0da6d6e85816c2e66d0d3c16f48e119e5c2b7dc4f728e76c008e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6855ca8e76e0da6d6e85816c2e66d0d3c16f48e119e5c2b7dc4f728e76c008e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "720ca6d16d639e777012c7dd2573660925195284b31e3edb05bc1a321113bb25"
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
