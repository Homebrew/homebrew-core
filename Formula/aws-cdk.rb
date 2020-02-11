require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.23.0.tgz"
  sha256 "c0159aaedc7f773395390dae47007d7e784d5b491ae400168678e62906a82487"

  bottle do
    cellar :any_skip_relocation
    sha256 "44d652e0258eaea9d1b742314988d5c9a695702d63084e111382e2e31420d56f" => :catalina
    sha256 "ff0ac4b06a2388ee314ff850d438d567d52cede7926dd09ce7058196f39a363d" => :mojave
    sha256 "758d6df53eb7b1a542f62dbf1ece60225835b7a036c0236d65c745b6a8c4819f" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "testapp"
    cd testpath/"testapp"
    shell_output("#{bin}/cdk init app --language=javascript")
    list = shell_output("#{bin}/cdk list")
    cdkversion = shell_output("#{bin}/cdk --version")
    assert_match "TestappStack", list
    assert_match version.to_s, cdkversion
  end
end
