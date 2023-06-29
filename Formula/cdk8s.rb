require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.79.tgz"
  sha256 "07e4b7f64a19fae6112f310f7f6d03f405e60c6727b222ad6e7c48f697d23957"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dba872e5200e3da567f81e3d9963707253c380178cc9dbd8a79de262b4a838b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dba872e5200e3da567f81e3d9963707253c380178cc9dbd8a79de262b4a838b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dba872e5200e3da567f81e3d9963707253c380178cc9dbd8a79de262b4a838b3"
    sha256 cellar: :any_skip_relocation, ventura:        "74f7f1d4bf073d4b5ae828b06ccb9f087aee1770f07969873c09421f23ebd2fe"
    sha256 cellar: :any_skip_relocation, monterey:       "74f7f1d4bf073d4b5ae828b06ccb9f087aee1770f07969873c09421f23ebd2fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "74f7f1d4bf073d4b5ae828b06ccb9f087aee1770f07969873c09421f23ebd2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dba872e5200e3da567f81e3d9963707253c380178cc9dbd8a79de262b4a838b3"
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
