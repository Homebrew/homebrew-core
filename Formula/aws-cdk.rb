require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.78.0.tgz"
  sha256 "3d231623cab2b05de37f178dde0dabce2a2eac9fefb1f2a6e0ed225a364abaf9"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "49aad1d15739cd942796e7c58bf1f537d36530e8a355b87eb17f1dd584cdbbe8" => :big_sur
    sha256 "f870f6e3df22c1b47103436e350509dd2dd818ddf68128b399914529e26f839d" => :catalina
    sha256 "06eb4582309c7f91846a916c7427269c592a5da6991a9e0cd6a598b9d867dd01" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
