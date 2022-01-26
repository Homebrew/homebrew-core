require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.9.0.tgz"
  sha256 "dd12e2e88e6ed4f5bd5ac5e9db172f7f5fad7dd36f9ccee89b3b628b4dbc8ec5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3b1acac013ab7e7d72dbca9e4c2e475d265eb0b7c4fcaeb1c19df92582bb98b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3b1acac013ab7e7d72dbca9e4c2e475d265eb0b7c4fcaeb1c19df92582bb98b"
    sha256 cellar: :any_skip_relocation, monterey:       "51d38cc770b8e2a2d36d1cf856cc2449620d59709a5ae73f604e4504c49bf586"
    sha256 cellar: :any_skip_relocation, big_sur:        "51d38cc770b8e2a2d36d1cf856cc2449620d59709a5ae73f604e4504c49bf586"
    sha256 cellar: :any_skip_relocation, catalina:       "51d38cc770b8e2a2d36d1cf856cc2449620d59709a5ae73f604e4504c49bf586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "705c3a0d570abb56f542e06eca5dbbfb648726c807215d401663a648bf3d5f4a"
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
