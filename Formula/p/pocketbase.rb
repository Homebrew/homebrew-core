class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.25.9.tar.gz"
  sha256 "62ead58e5462f168e5277aa5d155abaa4bd38fe6ef13493688960ef28c5e3f07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "000ee70d3e40211e043a585b9fc68b61f47d14003bd056426f9d326824dd60ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "000ee70d3e40211e043a585b9fc68b61f47d14003bd056426f9d326824dd60ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "000ee70d3e40211e043a585b9fc68b61f47d14003bd056426f9d326824dd60ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "78769af61dedc61151325e903c4a3a91ed564bff329c482065d8614ab2b66c98"
    sha256 cellar: :any_skip_relocation, ventura:       "78769af61dedc61151325e903c4a3a91ed564bff329c482065d8614ab2b66c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c084ad03996d340112fcb9e6a999a975859cef4eaec8bad20ed4bf959e0f9d02"
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

    assert_path_exists testpath/"pb_data", "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_path_exists testpath/"pb_data/data.db", "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_path_exists testpath/"pb_data/auxiliary.db", "pb_data/auxiliary.db should exist"
    assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end
