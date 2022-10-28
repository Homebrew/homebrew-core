require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.27.tgz"
  sha256 "ad320cc15d66ebcdf78f86832934facc7bc35a97e4dde87ddf4bb3209e793a27"
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
