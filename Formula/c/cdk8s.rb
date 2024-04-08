require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.94.tgz"
  sha256 "5fbc6098c3a28519e8c05a0a9a669e52f2db0cbce02f2419dd82331812334ac2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "531b4edf88a6059f9ec13cbc17968b7d583e82f5f1ebfab22b907e167a7bd98e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "531b4edf88a6059f9ec13cbc17968b7d583e82f5f1ebfab22b907e167a7bd98e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "531b4edf88a6059f9ec13cbc17968b7d583e82f5f1ebfab22b907e167a7bd98e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a065ac09085cf8a33c787838af3797c76e7737e07c309ec1803a473c063c981"
    sha256 cellar: :any_skip_relocation, ventura:        "7a065ac09085cf8a33c787838af3797c76e7737e07c309ec1803a473c063c981"
    sha256 cellar: :any_skip_relocation, monterey:       "7a065ac09085cf8a33c787838af3797c76e7737e07c309ec1803a473c063c981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "531b4edf88a6059f9ec13cbc17968b7d583e82f5f1ebfab22b907e167a7bd98e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
