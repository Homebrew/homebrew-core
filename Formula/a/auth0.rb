class Auth0 < Formula
  desc "Build, manage and test your Auth0 integrations from the command-line"
  homepage "https://auth0.github.io/auth0-cli"
  url "https://github.com/auth0/auth0-cli/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "dbf7ee6bd8b534a039d1e47da014fcf62ef5024860e0e1feb420a7bd4e1f3a5d"
  license "MIT"
  head "https://github.com/auth0/auth0-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4fce2a69396294375a741dd217e57e6740e81418d6f8828e1b460d054fd2d5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a4fce2a69396294375a741dd217e57e6740e81418d6f8828e1b460d054fd2d5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4fce2a69396294375a741dd217e57e6740e81418d6f8828e1b460d054fd2d5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ede2d9b917eed8c28a0550c0be23dbcb2f3185cd10b8c78bc51b07a1ece9584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "adb4be57afba2b97e91fcfb31460387ec9bdae93d9823f38e4ad1ab01e1561c7"
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
