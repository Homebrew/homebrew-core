require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.14.tgz"
  sha256 "349b1643f5312758e252fc87bad7b4733d33c3303e6cbf21b6029d451135f5dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a17126090030e5d1a83003aafb6437564580e1131dbd35b3f1b8fa47a7c5fefd"
    sha256 cellar: :any_skip_relocation, big_sur:       "30c004f6308260b37ae2154f0db1d96b74be3dac302a4637bdb2968688b43637"
    sha256 cellar: :any_skip_relocation, catalina:      "30c004f6308260b37ae2154f0db1d96b74be3dac302a4637bdb2968688b43637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db47e3c36554a6db6acc04682c2d30e7be167e85884f09d1dfeb4cefd7e54a88"
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
