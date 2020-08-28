require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.27.0.tgz"
  sha256 "77010866c1e04f3c4ef09bd9076b3adb32c8585f4580acebf7599d2834be861b"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f12ffcea2c703bd98a750c242710177cca5d802328703e413672c693c690e7b5" => :catalina
    sha256 "63ee4648aa040573202a75824168315424f1a5dcbe6325eda8617f2f9417c022" => :mojave
    sha256 "39cbaa2d931ae46ab8d419e7ebc24c76862b09c28148f93f3b7b33564b591c14" => :high_sierra
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
