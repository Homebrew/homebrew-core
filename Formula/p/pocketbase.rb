class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.5.tar.gz"
  sha256 "4a914714a689bd862f18993c524a66306f48abfa3a9edf973565bddd24eefe0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6e673ab110f2285d8af0c105e8b3af9c8d66b1fcc7c9ecf05757008d573868b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6e673ab110f2285d8af0c105e8b3af9c8d66b1fcc7c9ecf05757008d573868b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6e673ab110f2285d8af0c105e8b3af9c8d66b1fcc7c9ecf05757008d573868b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f8d5bb0b3d8e52153ba88a082d821cba0730482ddb1c30d0e90d14cc2495e28"
    sha256 cellar: :any_skip_relocation, ventura:        "3f8d5bb0b3d8e52153ba88a082d821cba0730482ddb1c30d0e90d14cc2495e28"
    sha256 cellar: :any_skip_relocation, monterey:       "3f8d5bb0b3d8e52153ba88a082d821cba0730482ddb1c30d0e90d14cc2495e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ab47ce8235b7bdbcfeacdf405de2309eabf447a79896d217cb71f362779a78e"
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
