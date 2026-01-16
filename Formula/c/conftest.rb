class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "cf639c2efa2410699e294689f1115298aa9dbc6587f198a839f27a310c18c6c0"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dcad1365b01900bf73ccf60ff30e8aa514c17f57d593917b74bf80a110c6757"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "913647567d26c4cb0cac241c8a9a3c880322a73dbd4ec2416331e06a6aed61e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19aa7682ffc4847dbed5d32b565412cd4155d9d7ee1c3d8acc0b15a2568eb62c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3f059bd9b5adbd2a5b5b9bd6b049932c24c14a1de35df5d042cd7b6bfa30378"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e83664bd32c398e990d83c893d262799f0369d688166f929189ea1d67da27986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdcdb4b32b2dbd8c511ebc0ac072f242ace0d2620b43f79f6b31e2bbc657a97b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end
