class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.27.0.tar.gz"
  sha256 "b1a38065a1de5208ed72250b257149e21e3381423e6e3028adb214fd4380f3ef"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "58bb6fc10b6d2728337d0ce92c17869973e5a2e8ac182cfae9e141bc0f0cf91d"
    sha256 cellar: :any_skip_relocation, big_sur:       "657d8aabc772e7b3b0646f0417ae76348464e05f5d42e171cde8233270166bb7"
    sha256 cellar: :any_skip_relocation, catalina:      "ad5139e20e4fec63d3bead139dd235ec3028af36ae6cab43333456ed277d4b02"
    sha256 cellar: :any_skip_relocation, mojave:        "b8f0738aa71f62cdf16aeed64b620794b054c0ed402567a6fc21c49a2ea8bd27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57e1b7e0b989eeec12879e7fe968f8de7c3cdebf7ca0d0b56c96a770801eafc0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
