class Netbird < Formula
  desc "Securely connects across any network with one identity-based platform"
  homepage "https://netbird.io"
  url "https://github.com/netbirdio/netbird/archive/refs/tags/v0.82.1.tar.gz"
  sha256 "faea65ed0321a285818ad4458da5b0441c6f6f766c9fd963cb7dfc5cd9bf4445"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a02bf0700c0bfd7e5f744612efe04c13a04f3ec8f4eada6e734dbe8624ae0a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a02bf0700c0bfd7e5f744612efe04c13a04f3ec8f4eada6e734dbe8624ae0a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a02bf0700c0bfd7e5f744612efe04c13a04f3ec8f4eada6e734dbe8624ae0a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "031cbdeaca9a00036c353966c168ed768388ad6af798aa61118d2fe6e5437029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e38ada1a9aede5817702b105d457fb523b49a7d0d67ba6521b8796ee1fb724c6"
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
