class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "37473dc4bfe2ea7b1da5646e1af5d102b9de493517f50ddad2821521f6d1e908"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a38639a1e73a15be8ee3e3b1cc395089be2a64b9ccaea5746902b261457c651c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a38639a1e73a15be8ee3e3b1cc395089be2a64b9ccaea5746902b261457c651c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a38639a1e73a15be8ee3e3b1cc395089be2a64b9ccaea5746902b261457c651c"
    sha256 cellar: :any_skip_relocation, ventura:        "137275bf4f349f14f596fc6f94e9b841945465aa5a4ec6b215f92fbffd9cdebb"
    sha256 cellar: :any_skip_relocation, monterey:       "137275bf4f349f14f596fc6f94e9b841945465aa5a4ec6b215f92fbffd9cdebb"
    sha256 cellar: :any_skip_relocation, big_sur:        "137275bf4f349f14f596fc6f94e9b841945465aa5a4ec6b215f92fbffd9cdebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574ec197ad5126e2a3457795a07ab552eb1ca97b7e9846aac10ffe3a3da0e0b6"
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
