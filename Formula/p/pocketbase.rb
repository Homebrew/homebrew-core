class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.22.21.tar.gz"
  sha256 "641f015a9c978f24741626898b470b4a01c2122731c4b7e8a057333122d5a967"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95598f3e44316728c91aa2291e59def859633d90b8e6bb838bc74aa26d76398c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95598f3e44316728c91aa2291e59def859633d90b8e6bb838bc74aa26d76398c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95598f3e44316728c91aa2291e59def859633d90b8e6bb838bc74aa26d76398c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ce3652993c1ae4af10c3c81a3a65e053016ce5a7b5af06fd10bf61839dd52e4"
    sha256 cellar: :any_skip_relocation, ventura:       "1ce3652993c1ae4af10c3c81a3a65e053016ce5a7b5af06fd10bf61839dd52e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "081685dc3b26e6eb08662673196889128a2baa15f59debea6ec35a18e6ad309f"
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
