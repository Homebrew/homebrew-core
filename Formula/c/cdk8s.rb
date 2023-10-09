require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.132.0.tgz"
  sha256 "9c87cdd3bf26e3864f77406d922549e160ffc476deaa2b303802a8ff111c3369"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39f379482c21aa5041ab2d4bc4c42c97bb22239a51d2bdfb61af80d31aa5819a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39f379482c21aa5041ab2d4bc4c42c97bb22239a51d2bdfb61af80d31aa5819a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39f379482c21aa5041ab2d4bc4c42c97bb22239a51d2bdfb61af80d31aa5819a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c46778e40c2335c304be1705a3bac1bc2f2526360717a5c6762e4072f6b3a59"
    sha256 cellar: :any_skip_relocation, ventura:        "6c46778e40c2335c304be1705a3bac1bc2f2526360717a5c6762e4072f6b3a59"
    sha256 cellar: :any_skip_relocation, monterey:       "6c46778e40c2335c304be1705a3bac1bc2f2526360717a5c6762e4072f6b3a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39f379482c21aa5041ab2d4bc4c42c97bb22239a51d2bdfb61af80d31aa5819a"
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
