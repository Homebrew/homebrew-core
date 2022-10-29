require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.30.tgz"
  sha256 "dbfe5f0e7e4b325c77dd897f6ae71f626809dbb1d8f3ddc49eb6a85c29399d8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "353ee949239385fa8fe26275844f7eac2ac4d515ca4a49ec3090881466637191"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "353ee949239385fa8fe26275844f7eac2ac4d515ca4a49ec3090881466637191"
    sha256 cellar: :any_skip_relocation, monterey:       "03896705c4f6f302b582273881939befea61804250fdd2b9d44a7fc6084db7a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "03896705c4f6f302b582273881939befea61804250fdd2b9d44a7fc6084db7a1"
    sha256 cellar: :any_skip_relocation, catalina:       "03896705c4f6f302b582273881939befea61804250fdd2b9d44a7fc6084db7a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "353ee949239385fa8fe26275844f7eac2ac4d515ca4a49ec3090881466637191"
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
