class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.42.1.tar.gz"
  sha256 "7f8aa6ae661c5555f4f71f3618188bd9eb01e69b7334d83648c5cfdf4ad396a1"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccbe2082028cab208728f0bdc250d45e07c2632a0d8a2adc44aa17f548e2eb27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccbe2082028cab208728f0bdc250d45e07c2632a0d8a2adc44aa17f548e2eb27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccbe2082028cab208728f0bdc250d45e07c2632a0d8a2adc44aa17f548e2eb27"
    sha256 cellar: :any_skip_relocation, ventura:        "abbcb2ec2d5f5532a483c053a10543fc493840d3cbdf01444e1ddba4dc096360"
    sha256 cellar: :any_skip_relocation, monterey:       "abbcb2ec2d5f5532a483c053a10543fc493840d3cbdf01444e1ddba4dc096360"
    sha256 cellar: :any_skip_relocation, big_sur:        "abbcb2ec2d5f5532a483c053a10543fc493840d3cbdf01444e1ddba4dc096360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a42c29dc9827d9a0eb027e15263eaa65688833d6cfb0cb400e37543089fb6e9"
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
