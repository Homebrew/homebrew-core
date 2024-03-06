class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "79a3786c7862072efaa0df9ebdf06b66215c1950da723361dabf54d07becefdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0eed8e6154308eb45b2ed7b1318ca3ae2fbb931e0e341e1153858908ef3909e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eed8e6154308eb45b2ed7b1318ca3ae2fbb931e0e341e1153858908ef3909e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eed8e6154308eb45b2ed7b1318ca3ae2fbb931e0e341e1153858908ef3909e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a63c7a81f3453e7c27067358ef25c88e80dba2995e6a4cf2b3df848e9f736379"
    sha256 cellar: :any_skip_relocation, ventura:        "a63c7a81f3453e7c27067358ef25c88e80dba2995e6a4cf2b3df848e9f736379"
    sha256 cellar: :any_skip_relocation, monterey:       "a63c7a81f3453e7c27067358ef25c88e80dba2995e6a4cf2b3df848e9f736379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "863cede63256491925966c09865312b5d16d912c707d1e29a7c69055d79f44f6"
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
