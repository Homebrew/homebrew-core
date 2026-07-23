class Auth0 < Formula
  desc "Build, manage and test your Auth0 integrations from the command-line"
  homepage "https://auth0.github.io/auth0-cli"
  url "https://github.com/auth0/auth0-cli/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "50d25c4b4bb89465664b558d00623008c0c366ae2596b440e3c0b3fbdaedd626"
  license "MIT"
  head "https://github.com/auth0/auth0-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "541888e73eb1ca643101373cac8e973316bd7d5cb883adab75b7ff2de2c04cd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541888e73eb1ca643101373cac8e973316bd7d5cb883adab75b7ff2de2c04cd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "541888e73eb1ca643101373cac8e973316bd7d5cb883adab75b7ff2de2c04cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a7baf8a8f518cacc79307f8942c506ba22500b7bcb0e741aaaf6a841ac2e5f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49ba104a4fb3ac6fbefad3e13d70e2d83379948df0df84abfd0f99996f4b47ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e57cc4bea454f1a1903cc01273429b50c404e14d2f473861f58d4e14d11fabda"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
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
