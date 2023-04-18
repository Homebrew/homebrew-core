require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.75.0.tgz"
  sha256 "a2a75bc1e740ff7ca1e415eff8750f3de04c369ef83338a0aa554c13e45b8d7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "429126311bc62921611506d9159cafcd53a68100318861ba0aa3613c3132fb86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "429126311bc62921611506d9159cafcd53a68100318861ba0aa3613c3132fb86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "429126311bc62921611506d9159cafcd53a68100318861ba0aa3613c3132fb86"
    sha256 cellar: :any_skip_relocation, ventura:        "724b619e084c8d87c06a9a82483a1e8cae1f56027b5b41da958671cc4a059030"
    sha256 cellar: :any_skip_relocation, monterey:       "724b619e084c8d87c06a9a82483a1e8cae1f56027b5b41da958671cc4a059030"
    sha256 cellar: :any_skip_relocation, big_sur:        "724b619e084c8d87c06a9a82483a1e8cae1f56027b5b41da958671cc4a059030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2115d37c65044bdd1a5faa81ccddb33af710ca02c0aadc2103bbd2d7febc2b"
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
