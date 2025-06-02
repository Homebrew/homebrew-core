class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "c067811e8e74068d6fa6473e2f0b31e5c221e33969e029c0b909ebf47c3bc135"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2198421aec656bd255a31bc7cbeaf29c5a71ba2be1d6555bd6b2f5fa85a4473f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3ac375a3099be69f23905d7c212d61dbfc14d4b43f3bcb23022c3b24724640"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3c9d2ba57490175bd0ffa6f8bba57ff980155ba864dcd46f5783b1b2efcb35a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3db569c6ddb5c382bca3a9009a7288f39601b0aadc3131db4606a7f97842d4f"
    sha256 cellar: :any_skip_relocation, ventura:       "dae732aa033885618333c955e1b37c55c400c9204fb038c65a80b8e816dee94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90e48d7795babd1de504ea222319c3ba7fa0f6a755a78640cd4d43d7d5090c28"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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
