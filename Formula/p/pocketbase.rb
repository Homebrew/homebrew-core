class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.18.8.tar.gz"
  sha256 "5b9d998bb3f81444ba2edf22931b6d2d85e3fb324ec4e35e93b0ba5db9faad4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ee045d6563080cf243181fd8de4ef640447b509a9acff36c6e6adea4cb4c3a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ee045d6563080cf243181fd8de4ef640447b509a9acff36c6e6adea4cb4c3a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ee045d6563080cf243181fd8de4ef640447b509a9acff36c6e6adea4cb4c3a1"
    sha256 cellar: :any_skip_relocation, ventura:        "e9096b1f36c42b17a99a0dc0fd9c96a331fa36fe4e992430ca91b6f4cb1b1e1c"
    sha256 cellar: :any_skip_relocation, monterey:       "e9096b1f36c42b17a99a0dc0fd9c96a331fa36fe4e992430ca91b6f4cb1b1e1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9096b1f36c42b17a99a0dc0fd9c96a331fa36fe4e992430ca91b6f4cb1b1e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b60b3125293472648c7b1d4b027d2b010990b0973089356e5b4b9e8f70c110e7"
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
