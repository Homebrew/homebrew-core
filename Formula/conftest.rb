class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.35.0.tar.gz"
  sha256 "01dc54d1a6828b87c560d71df788806f2245e28352d407f535524f6f300f8aa5"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e701a40383b9e466d6fb2fc4a767fdbfa36cdd6c4f864bf9b34328b36b037b17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63a1cea2c97080af56d08f855bd94021a077355cc714510e00a365099af6dff5"
    sha256 cellar: :any_skip_relocation, monterey:       "cfbbfade9c5ff65f386b13390870fe91e93780917a7a865dddd9f8c6545e3e56"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f8ca8b120d640adaedff17ed08b10862412f6819dcab877f39bdeed55e6188f"
    sha256 cellar: :any_skip_relocation, catalina:       "d8a33474dec9949abc454eb7ea4142ede3239b46ede87e25de18b695467ecf31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead58bf325b95c04868a3e95d10c336973f5914192a099c3ff67179cc53cfff8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
