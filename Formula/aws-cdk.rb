require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.62.2.tgz"
  sha256 "a81506720677995c884f49d1f9e84247c4dc2f6d4ae9f41dc58ead6556ea64b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "423ae2eba6ff002157c41405dacb96833872fe72a561409825452e81665ba1cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "423ae2eba6ff002157c41405dacb96833872fe72a561409825452e81665ba1cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "423ae2eba6ff002157c41405dacb96833872fe72a561409825452e81665ba1cf"
    sha256 cellar: :any_skip_relocation, ventura:        "366dd095a3b8e88a002c4546435f3190379934fb2d17387e3324c8063190d335"
    sha256 cellar: :any_skip_relocation, monterey:       "366dd095a3b8e88a002c4546435f3190379934fb2d17387e3324c8063190d335"
    sha256 cellar: :any_skip_relocation, big_sur:        "366dd095a3b8e88a002c4546435f3190379934fb2d17387e3324c8063190d335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "939f08044ab281144ca56e5b79e89f2de24bcdd55b1ba1f8c4e5ad734dd86b01"
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
