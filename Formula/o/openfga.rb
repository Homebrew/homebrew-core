class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "48c409e8f58e48d0646cd64aac8cc81c9b17bf46b4be5dc2ac25a1c376610d46"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df8a0a964d7273a35bcf626cfd57c71cb947996387e4764f329ea1df02aec534"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2eb008a5b5fee18c0aa9922afd033da94114f9f590df99a80027d14c2435888a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aeac0c31a450b58dafe87fb56038c2ada9154a0e213a6e1b0e55b71c54819ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "01fbbc040af32ba73e01288684615fbb501dd9ecda41f6d77a352c6450c81a68"
    sha256 cellar: :any,                 x86_64_linux:      "f737313388ef0ef65f43fa20caeb2d32a96b9a7146bdaf606bb975df4f6305b6"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
