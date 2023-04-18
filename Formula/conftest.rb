class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.41.0.tar.gz"
  sha256 "fd8fc0a4c43d18e0e0d1d0b12d3941d9ea271b4f30d797bb2f88297957112f47"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aecd8801772fbd45c30bfecdd67b6b23a86e3c793709e7e3db3aa03c2dc78384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aecd8801772fbd45c30bfecdd67b6b23a86e3c793709e7e3db3aa03c2dc78384"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aecd8801772fbd45c30bfecdd67b6b23a86e3c793709e7e3db3aa03c2dc78384"
    sha256 cellar: :any_skip_relocation, ventura:        "1a75266ef3219ebb61af376e58d5830ac187c9585fe9173cf72f9cf382e18f9c"
    sha256 cellar: :any_skip_relocation, monterey:       "1a75266ef3219ebb61af376e58d5830ac187c9585fe9173cf72f9cf382e18f9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a75266ef3219ebb61af376e58d5830ac187c9585fe9173cf72f9cf382e18f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c77ada381a0a45115648b42f16cbc091d1edd1b699cb330bd9b2d7a718fb8f2d"
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
