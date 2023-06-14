require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.59.tgz"
  sha256 "cac2d63a028dcfc44dfd73604729901d4873ceb9067b6e5cea83b3024fc38ee2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba86bbb85cfa4d9982a06ea77efedc6a4dd21a8ce9de4b4ea05e709f7a5d057a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba86bbb85cfa4d9982a06ea77efedc6a4dd21a8ce9de4b4ea05e709f7a5d057a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba86bbb85cfa4d9982a06ea77efedc6a4dd21a8ce9de4b4ea05e709f7a5d057a"
    sha256 cellar: :any_skip_relocation, ventura:        "bd6dcbda35f44a0582ffddaa4bbecff700cdb5d1f93799aa0baaf909bbabc6db"
    sha256 cellar: :any_skip_relocation, monterey:       "bd6dcbda35f44a0582ffddaa4bbecff700cdb5d1f93799aa0baaf909bbabc6db"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd6dcbda35f44a0582ffddaa4bbecff700cdb5d1f93799aa0baaf909bbabc6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba86bbb85cfa4d9982a06ea77efedc6a4dd21a8ce9de4b4ea05e709f7a5d057a"
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
