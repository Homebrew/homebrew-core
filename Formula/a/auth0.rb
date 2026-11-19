class Auth0 < Formula
  desc "Build, manage and test your Auth0 integrations from the command-line"
  homepage "https://auth0.github.io/auth0-cli"
  url "https://github.com/auth0/auth0-cli/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "c7b060e6290bfca852a3069961dfe3abffd7e5e5fcc4e92791b39c663a867473"
  license "MIT"
  head "https://github.com/auth0/auth0-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90b21b1fd26c57fcc1dafa20729bdd4010ee5e1ed87eefb433811b225df79171"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "90b21b1fd26c57fcc1dafa20729bdd4010ee5e1ed87eefb433811b225df79171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90b21b1fd26c57fcc1dafa20729bdd4010ee5e1ed87eefb433811b225df79171"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c980621b7277bd1cf65cf7003b66dadc7e47800d25e6931535472c7ac0384b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "861c37aea85a0e7de42c133abe4b18cf5963ef283aaa703111a6ac5b07ba3307"
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
