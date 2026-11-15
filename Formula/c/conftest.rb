class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.71.1.tar.gz"
  sha256 "1bf5a6ff4b9d7bd943b9713ace13c83c40b77fd3fcf2a9659f32be67c4a2c368"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c2b306fb1560944374b67ff2e5ea1d79abd99fe42277baa8684ca18f368210d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c2b306fb1560944374b67ff2e5ea1d79abd99fe42277baa8684ca18f368210d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c2b306fb1560944374b67ff2e5ea1d79abd99fe42277baa8684ca18f368210d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2eeedbb293d92583e484fe1442cbba07036be3647cba8ffa9ef7705046f8824d"
    sha256 cellar: :any,                 x86_64_linux:      "51fd7a108b7739364730e63f341d83b449ce9c9f0e1b7dd2417b5a496b4898ac"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/open-policy-agent/conftest/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conftest --version")
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end
