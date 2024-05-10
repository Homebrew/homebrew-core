require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.141.0.tgz"
  sha256 "089cee547490041cdd6d1939246877b9587a3e03f600fedab41927328b1e92a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1de648dcfd5e2828a255d3f66b8d36c283ca1249cdc8790a3946b8410c430418"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c320d886aec3a0c2cb41669914885aa88e74606bf072538ec7716844f8986a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faa316909e9de614513cddd833f5c1031800c5ec418dd92d1651d2c63e0cc990"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dfff9bcc21d847c5dc4141ff519149aa083f18459879440f07f44ffdfdae7a8"
    sha256 cellar: :any_skip_relocation, ventura:        "7a5d2077245b84a297851490a0de3a3562c3a7cc1376758e182df7602cdaf2b4"
    sha256 cellar: :any_skip_relocation, monterey:       "b2fc924a759efa4f83400527d19575f99d15d7dd8b0d20a3cab4b38bf042606a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c7a2a903f98dbf91c929b05199a951842ecc43bdd5552cb6049727a7eae13f"
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
