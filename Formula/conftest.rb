class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.42.1.tar.gz"
  sha256 "7f8aa6ae661c5555f4f71f3618188bd9eb01e69b7334d83648c5cfdf4ad396a1"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7a21f6eeca93a1b7311dd4741246915bf423ef2c730d30f3b7326a1bb66ff30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7a21f6eeca93a1b7311dd4741246915bf423ef2c730d30f3b7326a1bb66ff30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7a21f6eeca93a1b7311dd4741246915bf423ef2c730d30f3b7326a1bb66ff30"
    sha256 cellar: :any_skip_relocation, ventura:        "845579b2b72e4a98a24f9db6c05a0b622f1f2b11776f8b68524c78883b635922"
    sha256 cellar: :any_skip_relocation, monterey:       "845579b2b72e4a98a24f9db6c05a0b622f1f2b11776f8b68524c78883b635922"
    sha256 cellar: :any_skip_relocation, big_sur:        "845579b2b72e4a98a24f9db6c05a0b622f1f2b11776f8b68524c78883b635922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde74ab04a6b77ac49336aafd5692d077667d97be0f71d8ec3e49b7692377755"
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
