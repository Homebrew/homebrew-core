class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "7de35c59a28d72cf88985eb684011d80c6084a3cde5e3619a2aa00510f221e86"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2c03ffb8d912de7de1cb31fd5dd3165a0d8d6d349356347a27df9d6dc6fa57a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b08f2da2b7ce6601e54a8fb1558a0135eee4f6cf739b5a639988bc38f7270a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2759ad389dc831bc1f4cd23aaae763fb28ee1a8ca265fc3564fa7cf0bc715341"
    sha256 cellar: :any_skip_relocation, sonoma:         "1836c99f3b1699cde36a8c7bf292b13fbef70f8a284eab6f24bad4df2625c781"
    sha256 cellar: :any_skip_relocation, ventura:        "4ec5419859dc802a3fa9efc53d3d297a8d53664dc0ae9a6a45fee74fe06bf92a"
    sha256 cellar: :any_skip_relocation, monterey:       "e70e20161ba78c6153b0fbbcae59445b48675ce7ccfe4d588ebda94a5997a870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ad3589f92387e36c2a057b9a16753e362632ef8bdb2b2b2c2a4db6af46a54a0"
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
