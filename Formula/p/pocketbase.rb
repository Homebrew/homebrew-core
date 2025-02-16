class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.25.4.tar.gz"
  sha256 "7f53c68cbee9f022716205d80da45463bd8d20f274f308d60429849b9f707f5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4520ba5057d45136b7aebb9de55d2152afe1c81fb07319e916f14697a60dfcb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4520ba5057d45136b7aebb9de55d2152afe1c81fb07319e916f14697a60dfcb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4520ba5057d45136b7aebb9de55d2152afe1c81fb07319e916f14697a60dfcb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a96e73f45821e80e9fbafe2f011b0134ba0b24b95aabe63616cdfc5501d96f2b"
    sha256 cellar: :any_skip_relocation, ventura:       "a96e73f45821e80e9fbafe2f011b0134ba0b24b95aabe63616cdfc5501d96f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d664bcba771852d46ca991fa9b0f4e513a7da9b78b9ab70942a6833f16695a0"
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
