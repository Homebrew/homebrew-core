class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "b7c37da1f8b59f40e833b29179b2bf1ccd34cc04f5ab499f00e62cdff0c4042f"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d0f67ca939921c11305acc54260acf1c7551333d0a9cd6ad3c7143cede0f7c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5c3576b9ca634b83c447e9e1e4c7d582b208ad1c7d1419a71b9738700fc966f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "367a4fa40d8c15d5cb67eb263fcbd7c70eb02e3d14d9c0511a23f613b869063e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1988353eef453b85c9144ff6248a37dd9b186461db004669f4d7ed5c81435342"
    sha256 cellar: :any_skip_relocation, ventura:       "5b083fa345bb7d81326d9e9af7f4b5c316db526cee277ca70d5349860ae7a9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2554024f83b749cf4dc0b6d1be187a1d537c0f586f6f31bbcbb29a9619df5d3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
