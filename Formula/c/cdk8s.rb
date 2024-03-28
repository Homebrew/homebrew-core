require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.65.tgz"
  sha256 "443887a460097dbb51948fca50c006c699c7dad2befee3ca40066c67c4706936"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "204649d89f495cc5716b948cdff52c3337f934d69d9d2d45eb8d65ce363f325b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "204649d89f495cc5716b948cdff52c3337f934d69d9d2d45eb8d65ce363f325b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204649d89f495cc5716b948cdff52c3337f934d69d9d2d45eb8d65ce363f325b"
    sha256 cellar: :any_skip_relocation, sonoma:         "48f7a35958c15336a761f9c3420a9a7065de30c0b5674784b1396e0ef19dcd2e"
    sha256 cellar: :any_skip_relocation, ventura:        "48f7a35958c15336a761f9c3420a9a7065de30c0b5674784b1396e0ef19dcd2e"
    sha256 cellar: :any_skip_relocation, monterey:       "48f7a35958c15336a761f9c3420a9a7065de30c0b5674784b1396e0ef19dcd2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204649d89f495cc5716b948cdff52c3337f934d69d9d2d45eb8d65ce363f325b"
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
