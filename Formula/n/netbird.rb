class Netbird < Formula
  desc "Securely connects across any network with one identity-based platform"
  homepage "https://netbird.io"
  url "https://github.com/netbirdio/netbird/archive/refs/tags/v0.83.2.tar.gz"
  sha256 "e6d4d36da04017919f98b3724e51e1fe9982d803495ada1cdbc718eb0394cc48"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "92153670cf591f0bc00d9a5f397ec625de8fdbc884d72beb22f8010a7a487769"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b83d4f778af0b08a265314ef33c8bf931c61058315a8e0ffc3e77985391a3441"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b83d4f778af0b08a265314ef33c8bf931c61058315a8e0ffc3e77985391a3441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b83d4f778af0b08a265314ef33c8bf931c61058315a8e0ffc3e77985391a3441"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "944ba40dec52f1db08adfb612b9f28d3a128e7064326d6b92e786b1679cb0ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5c77026a38ee2b62e580c6c3649edf2cdfcb83af2d6373a1408944450f80fa1d"
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
