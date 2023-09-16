class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "386c68e85b415a3f9a7dcfd6c4341e2a842888702a893a4916834ccb5038e0f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74c9613ac772dfdd9eb21636e93f204b398341f554823347215011952ec5e8cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74c9613ac772dfdd9eb21636e93f204b398341f554823347215011952ec5e8cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74c9613ac772dfdd9eb21636e93f204b398341f554823347215011952ec5e8cc"
    sha256 cellar: :any_skip_relocation, ventura:        "4d5e7723adacae00281c9fcb4f6939c3ddb021698e77ebd3d21e39b6ebdb5ea9"
    sha256 cellar: :any_skip_relocation, monterey:       "4d5e7723adacae00281c9fcb4f6939c3ddb021698e77ebd3d21e39b6ebdb5ea9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d5e7723adacae00281c9fcb4f6939c3ddb021698e77ebd3d21e39b6ebdb5ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ea5ea08a25602457b71f8a2d1f3c2634099cce8cefa6d70a2ff7edf3ce4b4a"
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
