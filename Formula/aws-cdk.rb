require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.66.1.tgz"
  sha256 "fde67b7e93a8c0ef81b6ff1acb6b0eda37ae0509f966e72b8b92edf02dc67ebf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f686951290febaaa5c5725262d58846159a63ad1c26b09d40767c05aa16babe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f686951290febaaa5c5725262d58846159a63ad1c26b09d40767c05aa16babe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f686951290febaaa5c5725262d58846159a63ad1c26b09d40767c05aa16babe"
    sha256 cellar: :any_skip_relocation, ventura:        "cf2e81cf049e63bf7ad3a2e3af28eaa426fbc8f05f9642048b10eac73c045f7d"
    sha256 cellar: :any_skip_relocation, monterey:       "cf2e81cf049e63bf7ad3a2e3af28eaa426fbc8f05f9642048b10eac73c045f7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf2e81cf049e63bf7ad3a2e3af28eaa426fbc8f05f9642048b10eac73c045f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "679c13aca85dca38e1f7efc012cbe9eabaa35bdb614ec57f58c9e2a6eaa4f1f7"
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
