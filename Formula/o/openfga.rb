class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "73c3672da826ce48c62736b7780aebcc1bb5650f272c310302d8ff778939993f"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eea6ef3141e7e666cf4c14ef6b479364eb3560ed9c09cae4d068aa1199ef3416"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08e8b9e98c01d153dba3a7af6e91fbf7b27200e1d13b39c1200cdbd33512ac52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d31b6eaacd3903e6c2d353cef4914aa61fa80b32a2ae1c741dc740856cee7ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b22e03d0f18288ea6b0b8f6d37cc96f059c7989047329c5d12b0d0ef9aa0ac73"
    sha256 cellar: :any,                 x86_64_linux:      "74e8d11bd8571591f735d5222036f31f1d2d0d86fd2b34391112a23918bae32c"
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
