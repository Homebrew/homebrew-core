class Netbird < Formula
  desc "Securely connects across any network with one identity-based platform"
  homepage "https://netbird.io"
  url "https://github.com/netbirdio/netbird/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "2e90e715c774a056f0b4e5bf5650000bb5ec21d773ee70ef73fb2f44eb109d4a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4f899fd039ffacbf40c170b4b48c636363958d3ca9faee6299425f813ca1ddc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4f899fd039ffacbf40c170b4b48c636363958d3ca9faee6299425f813ca1ddc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d4f899fd039ffacbf40c170b4b48c636363958d3ca9faee6299425f813ca1ddc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9114b5cbbf25bb51b2f82d30f1d2048ccd246b35612e1446eac398d86496f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bf097f707b49e5be39c3323203d642cc18ed2b7a495d80a2e9559100e6bdc546"
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
