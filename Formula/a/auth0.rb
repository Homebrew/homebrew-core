class Auth0 < Formula
  desc "Build, manage and test your Auth0 integrations from the command-line"
  homepage "https://auth0.github.io/auth0-cli"
  url "https://github.com/auth0/auth0-cli/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "b4488d0d4d07e6aa810121801d49ba73ba66aafe3ebb5f3b993fabf88f51c8f9"
  license "MIT"
  head "https://github.com/auth0/auth0-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44fb517c005b10333cf61ff74873192453cd770b7e52ce2c2d75ebe8d8c4fbf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44fb517c005b10333cf61ff74873192453cd770b7e52ce2c2d75ebe8d8c4fbf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44fb517c005b10333cf61ff74873192453cd770b7e52ce2c2d75ebe8d8c4fbf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2da7774c2ae45bf46326e92f25220a99bf6a0515292b594f071b72886aa740a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97f27156f1da7191fb47e5e088859bbc7c72d970d096282880ec2a00e73fd716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3cdfb299da353dddead15367e838e4636c2058c2d33fbdf2c399fd63d208383"
  end

  depends_on "go" => :build

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
