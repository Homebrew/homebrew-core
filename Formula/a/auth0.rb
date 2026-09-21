class Auth0 < Formula
  desc "Build, manage and test your Auth0 integrations from the command-line"
  homepage "https://auth0.github.io/auth0-cli"
  url "https://github.com/auth0/auth0-cli/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "c1f4077981e9b25786f817f812d14cebeffd75779e2efa2f56e8dd40b9301904"
  license "MIT"
  head "https://github.com/auth0/auth0-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c47933861224aa88b1539f54b34cf9cb0d8586b0d5dd9675fdee1948baecc9b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c47933861224aa88b1539f54b34cf9cb0d8586b0d5dd9675fdee1948baecc9b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c47933861224aa88b1539f54b34cf9cb0d8586b0d5dd9675fdee1948baecc9b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4898f5f7995636be65835bc8e7870dd1e47e2f7b07521ac4c06922545cda409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6fbf9f641c361f5b9d2336f0ee3eb5ca281435471a090d01f0a01276d13d4738"
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
