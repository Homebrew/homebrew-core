require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.60.tgz"
  sha256 "e548b3ab4dc99672fedc9216604eb8bd1a5dc005716fa5132b2e8bf0f52a48e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3537e5645b13204b913402adb18e4deb5578018e45956ebff4c7a52fc937e888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3537e5645b13204b913402adb18e4deb5578018e45956ebff4c7a52fc937e888"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20542598fa49aea3e7bb86a321e281f436fd3e588b7fb388b1c4e4811058d3f2"
    sha256 cellar: :any_skip_relocation, ventura:        "6b59e32e4a30bcb77eed0d09a2354a324c585c8434e1bfb0e8779a160de108fd"
    sha256 cellar: :any_skip_relocation, monterey:       "6b59e32e4a30bcb77eed0d09a2354a324c585c8434e1bfb0e8779a160de108fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b59e32e4a30bcb77eed0d09a2354a324c585c8434e1bfb0e8779a160de108fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20542598fa49aea3e7bb86a321e281f436fd3e588b7fb388b1c4e4811058d3f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
