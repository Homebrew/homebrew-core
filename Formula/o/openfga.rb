class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.8.13.tar.gz"
  sha256 "5120ed422020a639cb34ce34ccef3731c5ccd543f7c2554d5d81e09ec26cc38e"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34d9128afe1d498354682caaaf906d6346146cc25c4ff9e72c9cacb3406a506f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a4e7435f39fbeefbf7b824810e0533465b58a9513f5cc0d9a140c58cb6b4456"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ce7b84c64a691edc3f93ced3c5aceabeb63d75164f58542aa219df0a0b98898"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea391b0e4e3584c8dc29c6633e27e4b158473b472f3017c8c82ed4822bd8d0ff"
    sha256 cellar: :any_skip_relocation, ventura:       "6344ebfa581b0fc379071f2e1d7199552e82c6abe96dfaa155aaab6576a7507e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa23287d30be7b64e73603d3666d035eaf7dad6c5e5560083855258036cd7475"
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
