class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.28.0.tar.gz"
  sha256 "0dd7314cd5c37c8184991d6834dc8a01c1d2f399e76b365a788054c2c5d53115"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "33bcb948579d556f11f9c9baefd5b6c12aa902c8100f6d1513b4013ff3a8f7fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d05da0e8877beb89bb49d0d68a7defcdaf3c7726c0e4a403d487cffc609cf36"
    sha256 cellar: :any_skip_relocation, catalina:      "0decbcdcc4b4df07a3c3d24f9cf6cfe597acc993d5aebd8aaa7c608c1a37da86"
    sha256 cellar: :any_skip_relocation, mojave:        "b9a1eccf970f0e7568b8198ffecb46ea1bad39db70210b697d7e222d8f5a8dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8272e1be7cc13c765c9ab0c6f7fc3782c6d9ca1ad0dbb130acd120fc2c2f13d2"
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
