class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.40.tgz"
  sha256 "2f041e7dde785b8003ac04de07081afbebaa6e88ccff5abca6b25062c7f1c056"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd4c1247f48597c4672cbbb68d38360edfa941330fcf4e69341e517772cb8e9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4c1247f48597c4672cbbb68d38360edfa941330fcf4e69341e517772cb8e9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd4c1247f48597c4672cbbb68d38360edfa941330fcf4e69341e517772cb8e9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "615864598573b81ea5b1e9279d99c90ee3e0cda49e60cd65d4d24f86eb663f38"
    sha256 cellar: :any_skip_relocation, ventura:       "615864598573b81ea5b1e9279d99c90ee3e0cda49e60cd65d4d24f86eb663f38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd4c1247f48597c4672cbbb68d38360edfa941330fcf4e69341e517772cb8e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd4c1247f48597c4672cbbb68d38360edfa941330fcf4e69341e517772cb8e9c"
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
