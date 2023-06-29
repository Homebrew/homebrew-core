class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.6.tar.gz"
  sha256 "0d7d47b8032d61b1f241334002b0a5991b6d443df3995ea1d42e6ab8a7d5bdbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b19fe8e83e037c6f3824b1cee278d9c862ae57d00f9039a01d5a737646b63e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b19fe8e83e037c6f3824b1cee278d9c862ae57d00f9039a01d5a737646b63e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b19fe8e83e037c6f3824b1cee278d9c862ae57d00f9039a01d5a737646b63e7"
    sha256 cellar: :any_skip_relocation, ventura:        "c95525c989643dc732cb2545f0b214ff4b94dc1375087decc59de68fd319cc78"
    sha256 cellar: :any_skip_relocation, monterey:       "c95525c989643dc732cb2545f0b214ff4b94dc1375087decc59de68fd319cc78"
    sha256 cellar: :any_skip_relocation, big_sur:        "c95525c989643dc732cb2545f0b214ff4b94dc1375087decc59de68fd319cc78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4836a222f42e15cf6a01d44cf7487de48edf34671ac99f870496fec9d2ae11cb"
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
