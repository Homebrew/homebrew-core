class Auth0 < Formula
  desc "Build, manage and test your Auth0 integrations from the command-line"
  homepage "https://auth0.github.io/auth0-cli"
  url "https://github.com/auth0/auth0-cli/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "be98893dc831faaf0fb8772f92183d9e2a4d980b7eec6b2de72d1a5e4770f31a"
  license "MIT"
  head "https://github.com/auth0/auth0-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2e168b06068abe8902d68a6bb3d87f920d4d71b10ff921cd010c575731ba91a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2e168b06068abe8902d68a6bb3d87f920d4d71b10ff921cd010c575731ba91a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2e168b06068abe8902d68a6bb3d87f920d4d71b10ff921cd010c575731ba91a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b23d55862d934f5a5cb720f4454c83840b8c33fac6996f0fffb55ebee3b76597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "497d2bf9659cd2e9ce882ce99352619e8f4ddf1e8498765da8a9258d03521dfa"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X github.com/auth0/auth0-cli/internal/buildinfo.Version=#{version}
      -X github.com/auth0/auth0-cli/internal/buildinfo.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/auth0"

    generate_completions_from_executable(bin/"auth0", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auth0 --version")

    # Without a tenant configured, the CLI exits non-zero with a clear message.
    output = shell_output("#{bin}/auth0 apps list 2>&1", 1)
    assert_match "Config.json file is missing", output
  end
end
