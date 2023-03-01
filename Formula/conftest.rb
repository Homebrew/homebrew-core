class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.39.2.tar.gz"
  sha256 "ad211fa198380adaa67864e1948d20fcec1acc7339f59bd2d1741a7ca83035ae"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0133bc1921943cd9c74f5b99dc9c02b0c333717d17f1fafa51a3bff07c78dc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0133bc1921943cd9c74f5b99dc9c02b0c333717d17f1fafa51a3bff07c78dc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0133bc1921943cd9c74f5b99dc9c02b0c333717d17f1fafa51a3bff07c78dc6"
    sha256 cellar: :any_skip_relocation, ventura:        "8a1debc6561537dee2ee1edfefe0302d5c0eae0a123b2aec3f82aef82da12a0b"
    sha256 cellar: :any_skip_relocation, monterey:       "8a1debc6561537dee2ee1edfefe0302d5c0eae0a123b2aec3f82aef82da12a0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a1debc6561537dee2ee1edfefe0302d5c0eae0a123b2aec3f82aef82da12a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1de052adef4532dca7b3c62a531e9da645449751955f6dd611cbf5b924fe8c"
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
