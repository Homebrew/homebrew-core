require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.101.1.tgz"
  sha256 "a653b3e19fb943c93ca3cd3622e3c9e5394a676cfa125b18e2ca44dc5624b9f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ad3e179cc34dfd3c892fd50296d3d18c763ac6a6b9253d0104d6fdb1ee6013a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ad3e179cc34dfd3c892fd50296d3d18c763ac6a6b9253d0104d6fdb1ee6013a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ad3e179cc34dfd3c892fd50296d3d18c763ac6a6b9253d0104d6fdb1ee6013a"
    sha256 cellar: :any_skip_relocation, sonoma:         "732d8b7f489d73096b989cffb3602859c02c73c06f151a36c17723890bc3f152"
    sha256 cellar: :any_skip_relocation, ventura:        "732d8b7f489d73096b989cffb3602859c02c73c06f151a36c17723890bc3f152"
    sha256 cellar: :any_skip_relocation, monterey:       "732d8b7f489d73096b989cffb3602859c02c73c06f151a36c17723890bc3f152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02dd69c583777c9b15a39eaf153977c7e731a3482947e0e3323a85874bafc660"
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
