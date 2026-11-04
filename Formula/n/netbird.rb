class Netbird < Formula
  desc "Securely connects across any network with one identity-based platform"
  homepage "https://netbird.io"
  url "https://github.com/netbirdio/netbird/archive/refs/tags/v0.82.0.tar.gz"
  sha256 "9553375fdd487572a4fdfeefd4cce95622686a80b8f0d10077c9913bebefe021"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9cda2ea118f6c6b7bdd2c8cb36ed8decc8d5b378bfa69fea558866f575014a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9cda2ea118f6c6b7bdd2c8cb36ed8decc8d5b378bfa69fea558866f575014a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9cda2ea118f6c6b7bdd2c8cb36ed8decc8d5b378bfa69fea558866f575014a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7fa188803d2da12044b84bfed295c3f256e4618eb4ac1c451baf5ea15c17f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "267e35d7e5dac75bacb763ff6005caf250749d16200570a21b240a1f901570d0"
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
