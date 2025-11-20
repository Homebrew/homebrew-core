class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "9fda76a9f7d151f3ac8ccddd713e059490f291efaff6351d1b806ab0f4a5dc10"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f44596df1e003203222ca1d7212be8055886460fc778f6c251cdcb5e8e58cc01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b868665b2d32b034192a92c771a2158d642e80175d0bd76f682afa9bba568a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8ff0abc1ffa553dbb14c532c34bf6e8e436751503462753fa41d3b5233a9f89"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f87e7dd6db323c8ed90d58c91cefc46d5348fc9329461947e1b120849dcface"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7779f1e5150ec2e2e251cc4a7af99539b44293967b56f38f426104f89a15178e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3635ae5a1bdeb354522877b2af27218f6a3e4a57fff77844b1aeb8e085ab6937"
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
