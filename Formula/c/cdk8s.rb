require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.46.0.tgz"
  sha256 "f331a014bcc478b5da92cef967ead5dda3b360cb0f2721c6f4555fcb4391bb86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f40e617d1dd2cd10e09185013cd14a4b59108a2aa362e9a9a7a8fc97ed1b32d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f40e617d1dd2cd10e09185013cd14a4b59108a2aa362e9a9a7a8fc97ed1b32d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f40e617d1dd2cd10e09185013cd14a4b59108a2aa362e9a9a7a8fc97ed1b32d8"
    sha256 cellar: :any_skip_relocation, ventura:        "bdded779c21751191fac5b703d68fda27d99a14c611c513afef94d4da64c6e68"
    sha256 cellar: :any_skip_relocation, monterey:       "bdded779c21751191fac5b703d68fda27d99a14c611c513afef94d4da64c6e68"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdded779c21751191fac5b703d68fda27d99a14c611c513afef94d4da64c6e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f40e617d1dd2cd10e09185013cd14a4b59108a2aa362e9a9a7a8fc97ed1b32d8"
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
