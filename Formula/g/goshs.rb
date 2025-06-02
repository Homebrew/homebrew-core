class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "a3e68619711bd0de75fd4c4547b0f439a72a280422d91723185c79b60c02ce16"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb5859b62d75c721feda62a1c5e6f607bec279b3562a4f207aa64e749fd3c39b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb5859b62d75c721feda62a1c5e6f607bec279b3562a4f207aa64e749fd3c39b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb5859b62d75c721feda62a1c5e6f607bec279b3562a4f207aa64e749fd3c39b"
    sha256 cellar: :any_skip_relocation, sonoma:        "333372b8cbef048974a4f40ac93ec634d15964b2454dd73492237b448a9f5076"
    sha256 cellar: :any_skip_relocation, ventura:       "333372b8cbef048974a4f40ac93ec634d15964b2454dd73492237b448a9f5076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7963579cb2c9597ac6e7fcd74d53e83e9f4d1633eff6cfc2c8a5241941a6e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goshs -v")

    (testpath/"test.txt").write "Hello, Goshs!"

    port = free_port
    server_pid = spawn bin/"goshs", "-p", port.to_s, "-d", testpath, "-si"
    sleep 2
    output = shell_output("curl -s http://localhost:#{port}/test.txt")
    assert_match "Hello, Goshs!", output
  ensure
    Process.kill("TERM", server_pid)
    Process.wait(server_pid)
  end
end
