class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.24.4.tar.gz"
  sha256 "1a6a8aa268c6c4b989b97ecd01ea3c7d5cc869bffcaa923987115ea01c895373"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dd68090eaf93cc0e644183de4ac89af029d815477a1e8589fea329a5d428414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dd68090eaf93cc0e644183de4ac89af029d815477a1e8589fea329a5d428414"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3dd68090eaf93cc0e644183de4ac89af029d815477a1e8589fea329a5d428414"
    sha256 cellar: :any_skip_relocation, sonoma:        "83cb62f90f4f10c8a61ba4900b031c1149b3490276ad62ff19a037ae10058d86"
    sha256 cellar: :any_skip_relocation, ventura:       "83cb62f90f4f10c8a61ba4900b031c1149b3490276ad62ff19a037ae10058d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59821107e637d099b4ae2a4b11b6645279bac2504c45598089de98dbd77f4014"
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

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/auxiliary.db", :exist?, "pb_data/auxiliary.db should exist"
    assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end
