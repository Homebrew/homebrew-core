class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.13.tar.gz"
  sha256 "e9af6e048f9ad342aebd34980b62ff70675aa7fb1001ef2a773e17526bdaea0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fe63c3d8fdbe37df966f9ca44fe319d46ab01183e0b1372409a2a86afbb0a97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fe63c3d8fdbe37df966f9ca44fe319d46ab01183e0b1372409a2a86afbb0a97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fe63c3d8fdbe37df966f9ca44fe319d46ab01183e0b1372409a2a86afbb0a97"
    sha256 cellar: :any_skip_relocation, sonoma:         "47622730dc370249437fea990b1c0ad2a9059abb2ee7b28b56b631e3fcab2d91"
    sha256 cellar: :any_skip_relocation, ventura:        "47622730dc370249437fea990b1c0ad2a9059abb2ee7b28b56b631e3fcab2d91"
    sha256 cellar: :any_skip_relocation, monterey:       "47622730dc370249437fea990b1c0ad2a9059abb2ee7b28b56b631e3fcab2d91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c2e02732532ee737af563432a777cad784f0cdb5cb0562f4a531bbd835ba57a"
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
