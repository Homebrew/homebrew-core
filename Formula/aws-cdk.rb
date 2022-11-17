require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.50.0.tgz"
  sha256 "9f1da0fbc8121071e698ddeea72c6903b9a34203c29d29847476e9b4697f1759"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "688ccff235c7759ab003b1a61729819f9626dd1b5327fc78248a9e86efc966b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "688ccff235c7759ab003b1a61729819f9626dd1b5327fc78248a9e86efc966b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "688ccff235c7759ab003b1a61729819f9626dd1b5327fc78248a9e86efc966b9"
    sha256 cellar: :any_skip_relocation, ventura:        "a9b745a912661215a8506a3581019a6576698cf93e31b331f6e1beee2db7a82e"
    sha256 cellar: :any_skip_relocation, monterey:       "a9b745a912661215a8506a3581019a6576698cf93e31b331f6e1beee2db7a82e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9b745a912661215a8506a3581019a6576698cf93e31b331f6e1beee2db7a82e"
    sha256 cellar: :any_skip_relocation, catalina:       "a9b745a912661215a8506a3581019a6576698cf93e31b331f6e1beee2db7a82e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ba29277d8e3a7bb5a1ea453fd56c48d5b62b93bfe7f5f908134d04794a12daf"
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
