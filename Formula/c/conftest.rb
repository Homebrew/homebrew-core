class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "fee1de2a5e7a094728ff5c8f754492e9c90180fde23b63299c0393c14c6c1e11"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8fda5e949ad4b2e6588ba8c5d92136190668310616494bc1f73e2a59ac25865f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97faabe0071274267d32e4f1b557034139e25e32c9920ea8b269d7f7bc2fd52c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c08d354576f9ce7c7c762ff1a382484a76000c2c88f82149ec87d886aeb3a9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "295bb7ba97435b76193b2d65632ab23f0c5a5b84ab141ac9e29a0e126fd953b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "900a259adb4eca4d00199c164a0eaabbb77e3dc9a8349b77825d27e8df7a0c3c"
    sha256 cellar: :any_skip_relocation, ventura:        "aa86394ffeee100bfaab4d29bf77722af07616dad5a75c1e1f400ff9431078cb"
    sha256 cellar: :any_skip_relocation, monterey:       "46a97df86819ba444be427edc6d8e076ba2c661b16d187e9178ad7bf31f4ce0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "830b78d108854083af7bd2d3983a2bcff3bef7cb66eda00f69a2665b2b05c6b0"
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
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end
