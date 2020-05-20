require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.40.0.tgz"
  sha256 "4a78668e77d3e68dc83b3cf849d8e0ed0d208ae45276e5238c55b914a5aa6f6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "52dfa1cd686bcfe1948dfc7dff2b6d660d95f24c229d4926450d05ff5be4f2c0" => :catalina
    sha256 "21e9b239315dce102e15049823be5f2676f0010b4ea19f4da2f6fcad545f2df9" => :mojave
    sha256 "09ebc5f88c3c543bdb0d6c932bc7fa24c5c610cf624bfe685053217fca08883e" => :high_sierra
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
