class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.102.tgz"
  sha256 "d487ebbe4043b99962802d361348236e942979c113e01e27777497eede59f165"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "113f889e79ae67f9ae4a8eaca283f0beef73f848f71def721c44b134cf400cf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "113f889e79ae67f9ae4a8eaca283f0beef73f848f71def721c44b134cf400cf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "113f889e79ae67f9ae4a8eaca283f0beef73f848f71def721c44b134cf400cf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "47ddb5233dc42d8a9ee1015c1213691082e8c7b059ebd5da0a3fa44d755ad3f7"
    sha256 cellar: :any_skip_relocation, ventura:       "47ddb5233dc42d8a9ee1015c1213691082e8c7b059ebd5da0a3fa44d755ad3f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "113f889e79ae67f9ae4a8eaca283f0beef73f848f71def721c44b134cf400cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "113f889e79ae67f9ae4a8eaca283f0beef73f848f71def721c44b134cf400cf9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
