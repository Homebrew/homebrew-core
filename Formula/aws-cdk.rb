require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.106.0.tgz"
  sha256 "09fbb0bdd2ea19c33e817d9aa73d7944c7346cf0e4936552e78ff9e818c9bc52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5f1b063ca9b0ed0e64f881f2757660f669da1dee896e7daca626676c588e41ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "7602ae966174baf89296e3ab6136125a6dc612363f6f22da12381eb78fcb6f1d"
    sha256 cellar: :any_skip_relocation, catalina:      "7602ae966174baf89296e3ab6136125a6dc612363f6f22da12381eb78fcb6f1d"
    sha256 cellar: :any_skip_relocation, mojave:        "7602ae966174baf89296e3ab6136125a6dc612363f6f22da12381eb78fcb6f1d"
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
