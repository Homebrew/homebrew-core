class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.6.tar.gz"
  sha256 "e39e5426ff10c764c7230ebe11545df0856ecdce6dfa1ae6d75b4f95a7a9a2a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7bf974f34c6b778c8541cff5670aa3095f0499bd2f3db7ab75a25b539e29669"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7bf974f34c6b778c8541cff5670aa3095f0499bd2f3db7ab75a25b539e29669"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7bf974f34c6b778c8541cff5670aa3095f0499bd2f3db7ab75a25b539e29669"
    sha256 cellar: :any_skip_relocation, sonoma:         "be842f52dda613d776809f169105ea1a3091fe4cc60e056497d2ee22d1d037cf"
    sha256 cellar: :any_skip_relocation, ventura:        "be842f52dda613d776809f169105ea1a3091fe4cc60e056497d2ee22d1d037cf"
    sha256 cellar: :any_skip_relocation, monterey:       "be842f52dda613d776809f169105ea1a3091fe4cc60e056497d2ee22d1d037cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d5fba80569ee91511a9575832c7d1d95dd847784806e597eef3d7208d3ccc00"
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
