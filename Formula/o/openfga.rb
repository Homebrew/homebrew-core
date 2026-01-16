class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "e455688ea9c923401b51540106770dc80a2245e3dfce9ba7be6e47e3988e37f7"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "359ac191d6ec07707a18e983a241c1a9bae17464ed2ee91a6a68c8317b1897fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a473ffcd15c6396d018fcf935762180edaaa94b668bf35f6d148dea1928f4053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9afc40b3cf0b92365bfe9511475318a509b52fd04dfd7f57ae06ea889e2a080f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6a190e859a6be16744ddb379bdb54e25935a2b4b79649180ef596f8183976a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4fd9c8635e8220fa08a350e3f58054e6c7eb6d31b5757869346f4f0caa5079c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a3050fdceaf2cd52650e533d05857f9c21f9fa2dad395b4aae91c33abf0638"
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
    pid = spawn bin/"openfga", "run", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
