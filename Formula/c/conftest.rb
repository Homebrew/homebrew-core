class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "a1075bdc2c7049464f5a158820c88e4cd21d81c8b5b25643f7d0adde3811ac03"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3071d37692107ba5e0bf17b7e40a55aba465dd60c042fdcf33b44fcca449080d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3071d37692107ba5e0bf17b7e40a55aba465dd60c042fdcf33b44fcca449080d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3071d37692107ba5e0bf17b7e40a55aba465dd60c042fdcf33b44fcca449080d"
    sha256 cellar: :any_skip_relocation, sonoma:        "921422caeb0485ba3f090d534cec8eb28fb2f92131513092fa24eb97fb402dcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f0b673533dfddc6b30ced8cdb763c433a85e9c0d89f29aa4036d97ac0f46f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb88fef50e43e096d86f68839ccd00cab643cae4e8e7b152fef62ba771a073d8"
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
