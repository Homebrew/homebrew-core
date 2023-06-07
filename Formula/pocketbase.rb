class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "618e18bad9b78dd230cf3c68cab9842e22fdab430ee527f3ebb728746c2d7b10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12e5fd9bc32dcefc2dfbaab01cd463c2602ddba859852d86e14678556883dd67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12e5fd9bc32dcefc2dfbaab01cd463c2602ddba859852d86e14678556883dd67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12e5fd9bc32dcefc2dfbaab01cd463c2602ddba859852d86e14678556883dd67"
    sha256 cellar: :any_skip_relocation, ventura:        "e027e651d0dbd280ea1d4aa50265b2cd823f0d70575ec6d0878b3791cdb4cfd6"
    sha256 cellar: :any_skip_relocation, monterey:       "e027e651d0dbd280ea1d4aa50265b2cd823f0d70575ec6d0878b3791cdb4cfd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e027e651d0dbd280ea1d4aa50265b2cd823f0d70575ec6d0878b3791cdb4cfd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e81d264a579d1cab8e6dfa7b58e8576aee437414a02b0bd68b6c9b28c2d24b2"
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
