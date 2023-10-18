class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "2d10e8b868e0bb7067fba63a02ea98f2925d2854586870be96a98e97d7aaeb52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6215454751c415f348593eebbd909fe1db30fcca201c06ff90ae72260f26b7d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6215454751c415f348593eebbd909fe1db30fcca201c06ff90ae72260f26b7d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6215454751c415f348593eebbd909fe1db30fcca201c06ff90ae72260f26b7d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b483bbaba00e1ab533c1405dc958ec6913ea855620652e728928626242a63ea5"
    sha256 cellar: :any_skip_relocation, ventura:        "b483bbaba00e1ab533c1405dc958ec6913ea855620652e728928626242a63ea5"
    sha256 cellar: :any_skip_relocation, monterey:       "b483bbaba00e1ab533c1405dc958ec6913ea855620652e728928626242a63ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d7c16f5a8099298e6172058e3890d89c6854a4e1b989f2d4b18b529d8b08c6f"
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
