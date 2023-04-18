require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.12.tgz"
  sha256 "6993fa40c3e83477eb60c93e5c7340a7e00995cd0033fa06001a93807fd6ef27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1f3c6a52089136c78c40874ede96a4fa11c2636069117697297cbb2aa497125"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1f3c6a52089136c78c40874ede96a4fa11c2636069117697297cbb2aa497125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1f3c6a52089136c78c40874ede96a4fa11c2636069117697297cbb2aa497125"
    sha256 cellar: :any_skip_relocation, ventura:        "2afe1ccdaab3862f423a92e5d9147009f0d9cd3ada0db1bc447d4c32256fd7ae"
    sha256 cellar: :any_skip_relocation, monterey:       "2afe1ccdaab3862f423a92e5d9147009f0d9cd3ada0db1bc447d4c32256fd7ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "2afe1ccdaab3862f423a92e5d9147009f0d9cd3ada0db1bc447d4c32256fd7ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f3c6a52089136c78c40874ede96a4fa11c2636069117697297cbb2aa497125"
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
