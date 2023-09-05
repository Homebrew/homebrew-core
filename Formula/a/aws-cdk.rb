require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.94.0.tgz"
  sha256 "8c7a966dfe7e3dfc02444891e23580573e6cf67ae7c4c3c43721bbebd90a9e6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6e6a987526354da6979102c4ab00a538c2bc9b81cc2af23b00617fad6c4f4e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6e6a987526354da6979102c4ab00a538c2bc9b81cc2af23b00617fad6c4f4e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6e6a987526354da6979102c4ab00a538c2bc9b81cc2af23b00617fad6c4f4e8"
    sha256 cellar: :any_skip_relocation, ventura:        "3baf82dd288f2f87d2a1987f684c18f7cd95ea553f46020a2f43e60345e936bf"
    sha256 cellar: :any_skip_relocation, monterey:       "3baf82dd288f2f87d2a1987f684c18f7cd95ea553f46020a2f43e60345e936bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3baf82dd288f2f87d2a1987f684c18f7cd95ea553f46020a2f43e60345e936bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "306ebc78c68603a1e843b1f16a5ca6621c4d9117ab4bf68c237cd2c49d62fbca"
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
