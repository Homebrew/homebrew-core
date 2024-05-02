class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.10.tar.gz"
  sha256 "0e77b52237686f035c3951dcaf525714d63a9c532f65bef594e1e1d0baff587e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ec1fc703063e9e047421231dd6ca903dbdc1f764a5130bd5efac6489953ee09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ec1fc703063e9e047421231dd6ca903dbdc1f764a5130bd5efac6489953ee09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ec1fc703063e9e047421231dd6ca903dbdc1f764a5130bd5efac6489953ee09"
    sha256 cellar: :any_skip_relocation, sonoma:         "036520255e799997b1c86a1133edd0930da30dbed4927eb3ddf46b1088ef3b94"
    sha256 cellar: :any_skip_relocation, ventura:        "036520255e799997b1c86a1133edd0930da30dbed4927eb3ddf46b1088ef3b94"
    sha256 cellar: :any_skip_relocation, monterey:       "036520255e799997b1c86a1133edd0930da30dbed4927eb3ddf46b1088ef3b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d6f3525613837cd755dc9cd395944d77de634dcf03e7d12c3c041fe8b11d1c4"
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
