class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "c62b8e2b7a0674e6642f87464ac82f1d608f3299178dce440078c6ddcf002f17"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae93437e7ecf6e6ff0de7a5d339b04ccd087f0a8be02387e51dcd4a138ec1f1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15807d3a62bebdfea337a537be7df8bca2140f429ab1c899d8ddfec94896763e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09bf7dd886a884b3c2140a8876a4cc12679a85ad8a717fcce84ee911785a6225"
    sha256 cellar: :any_skip_relocation, sonoma:        "07ed8fed24ab6a8dcd47b1636767ab32aebd8c270264c18f3f2ebcda44676c9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c50eedd5d4515a417802f4157a9ae7d8ac2eeec3cb030c44b668b9d9f3d05db9"
    sha256 cellar: :any,                 x86_64_linux:  "590b83a1e4da578ec7c55bd1bc4dc2bda00b3dd944de3c2f311b38b78124705e"
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
