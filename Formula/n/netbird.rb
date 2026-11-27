class Netbird < Formula
  desc "Securely connects across any network with one identity-based platform"
  homepage "https://netbird.io"
  url "https://github.com/netbirdio/netbird/archive/refs/tags/v0.84.0.tar.gz"
  sha256 "ef580ded91491c5c040bdd6e7e89fe5e3fc6c7882be74c4f1e8a53dcd6c04bbf"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "c19b4dd1254968ed672a39f135f6abe721a24ec6a8df2457db4cf0832d884285"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6cb0615136c5b211f3e24dea1a22ebd1b67a366a2b9ebaed6f0c7e8cbc1c2d8f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cb0615136c5b211f3e24dea1a22ebd1b67a366a2b9ebaed6f0c7e8cbc1c2d8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6cb0615136c5b211f3e24dea1a22ebd1b67a366a2b9ebaed6f0c7e8cbc1c2d8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e48da555d29ab704d4e5bf5ed0841ea962c999d601e00a15556da2ae9148c9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cfe6d11a64613c9901e6915323bdc253641d5bbed2a12fec87bb33107ddefcc5"
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
