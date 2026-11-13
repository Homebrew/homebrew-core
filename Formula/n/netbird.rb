class Netbird < Formula
  desc "Securely connects across any network with one identity-based platform"
  homepage "https://netbird.io"
  url "https://github.com/netbirdio/netbird/archive/refs/tags/v0.83.1.tar.gz"
  sha256 "5c8d32eab039acfa5720f280685bf864a7851504a0077a78d20b2f7cf6168f0f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ca14b4bc96e43cca2bb8b9814021b883a021e3bb2fe3373ac1fc32bcdf8360c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ca14b4bc96e43cca2bb8b9814021b883a021e3bb2fe3373ac1fc32bcdf8360c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ca14b4bc96e43cca2bb8b9814021b883a021e3bb2fe3373ac1fc32bcdf8360c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1398ed8ac4fc0edce489d3219bb1632e3feb42e821b49d95c74cb35c9383375d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9474b7308b398a47ecc323b70ee4e7c3abdf88707336ee72139f9df4ee64404d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/netbirdio/netbird/version.version=#{version}
      -X main.commit=NONE
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./client"
    generate_completions_from_executable(bin/"netbird", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netbird version")
    status_output = shell_output("#{bin}/netbird status --daemon-addr unix://#{testpath}/netbird.sock 2>&1", 1)
    assert_match "failed to connect to {Addr: \"#{testpath}/netbird.sock\"", status_output
  end
end
