class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.17.7.tar.gz"
  sha256 "42af7e2102a9a780c3d0bf7a9e2c1f95965c3fcb003149ca6325e539d9bbce9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5629098df8c7054b3720bbe13cacfee92874a77ea7a4afb6ab0fd7739ca37524"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5629098df8c7054b3720bbe13cacfee92874a77ea7a4afb6ab0fd7739ca37524"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5629098df8c7054b3720bbe13cacfee92874a77ea7a4afb6ab0fd7739ca37524"
    sha256 cellar: :any_skip_relocation, ventura:        "48b28bf4e669137c4a834c892689de46a8abe8b23c7231d7e439f6b37e4e17ed"
    sha256 cellar: :any_skip_relocation, monterey:       "48b28bf4e669137c4a834c892689de46a8abe8b23c7231d7e439f6b37e4e17ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "48b28bf4e669137c4a834c892689de46a8abe8b23c7231d7e439f6b37e4e17ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69e951214cd23dd690ea1d10ba1f79118897b72a9db506fb8882a0da76b90642"
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
