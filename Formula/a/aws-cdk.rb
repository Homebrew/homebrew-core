require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.96.2.tgz"
  sha256 "b38c5d2c72eb5f978949c74f5eaf6f1d0fa53eb1dce6abea54dd7f3f1db673f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66089c8b76fbec6d521bf09b22cf0e4adf6508f60de65403f80e746e84ce34a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66089c8b76fbec6d521bf09b22cf0e4adf6508f60de65403f80e746e84ce34a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66089c8b76fbec6d521bf09b22cf0e4adf6508f60de65403f80e746e84ce34a1"
    sha256 cellar: :any_skip_relocation, ventura:        "894be651e95461e43bb5237a5be6d14c7a71a76e778aa99e535aa98d3ce26b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "894be651e95461e43bb5237a5be6d14c7a71a76e778aa99e535aa98d3ce26b1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "894be651e95461e43bb5237a5be6d14c7a71a76e778aa99e535aa98d3ce26b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b8d3f8b65c11e86bb40167809cc892ab9a50bdb7aa6566053c3840cd1481901"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
