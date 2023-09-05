class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "906fe9d3cfdeac6f18b4d401ad36abec2cbbbdf1e60247be235fb6659df80020"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccc96301efd772be920ad31a54250c4fa21ffb7c688a3ca51a971e6761cb5ace"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccc96301efd772be920ad31a54250c4fa21ffb7c688a3ca51a971e6761cb5ace"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccc96301efd772be920ad31a54250c4fa21ffb7c688a3ca51a971e6761cb5ace"
    sha256 cellar: :any_skip_relocation, ventura:        "aed374872ad81dc86b1dc8f2357786164511fc44480c8729b93fd3f6fac7c841"
    sha256 cellar: :any_skip_relocation, monterey:       "aed374872ad81dc86b1dc8f2357786164511fc44480c8729b93fd3f6fac7c841"
    sha256 cellar: :any_skip_relocation, big_sur:        "aed374872ad81dc86b1dc8f2357786164511fc44480c8729b93fd3f6fac7c841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9511b68cf62e8403b7c9be25bea67fc774feed89b70943e0c150cb49b92355be"
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
