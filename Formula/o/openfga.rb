class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "49f89d90e01ba8e8e4e5342dbf9d70c667b2f6d0e54293c22de31bee4c219420"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce465a2a753c7e3f147711075c0d1827213c9ba1c9034c441ef35dca4a8a1302"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5bdfbb83f787674bf9a9cd18f991191edc3549918d48f276305191e5bd0e483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4db45f534872e73408a4b9f65075a2db3418b15022d40943bd4bbe5f25f15f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "755769db87eb0ec91b7b9a470f12efe6f1008154e36a774974fa4fea6e0a477f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5093287e12cedbff035c163dec47e1de07ff2c23e8e1a0dbd2e66e5ea689369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf1f8585affaf29aacfc0b3a22bd138388fe8030fde652e6080d58df0b64009"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-enabled", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
