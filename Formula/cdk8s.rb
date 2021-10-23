require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.11.tgz"
  sha256 "ba6c8097a6a958187ffb43ccff5e6a1975a4a2322aba9787e3732393a6ae314e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d511825624aeb85e38f52e7c0087733773d05caf55ca08c30372290adf11f521"
    sha256 cellar: :any_skip_relocation, big_sur:       "d8ba2020415de24222c4778c521f1b923139f73a2bccac286e79a55076b86b1e"
    sha256 cellar: :any_skip_relocation, catalina:      "d8ba2020415de24222c4778c521f1b923139f73a2bccac286e79a55076b86b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d511825624aeb85e38f52e7c0087733773d05caf55ca08c30372290adf11f521"
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
