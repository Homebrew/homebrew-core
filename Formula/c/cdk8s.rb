class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.11.tgz"
  sha256 "245b4a251d5b7c254e802e63e5673beffee47dc97da770fb045876bfbc8eb381"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70ac9d02f035a8b09261b8db1a3627dfdf2a0f0f3e3470a6dcaafe31a77ab90f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70ac9d02f035a8b09261b8db1a3627dfdf2a0f0f3e3470a6dcaafe31a77ab90f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70ac9d02f035a8b09261b8db1a3627dfdf2a0f0f3e3470a6dcaafe31a77ab90f"
    sha256 cellar: :any_skip_relocation, sonoma:        "19b3822aa081691aaf65ada6a32a9bd279da54cb16ebaa7e8de896414f0c91e0"
    sha256 cellar: :any_skip_relocation, ventura:       "19b3822aa081691aaf65ada6a32a9bd279da54cb16ebaa7e8de896414f0c91e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70ac9d02f035a8b09261b8db1a3627dfdf2a0f0f3e3470a6dcaafe31a77ab90f"
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
