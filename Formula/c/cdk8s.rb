class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.53.tgz"
  sha256 "fc1f5d90d8c7150babb582e804b1e34c522b275173f70a1aeeeb9d3dbbc5113c"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c33f490d6aa28b505162dd9befb9efe1589dc706b53c60b267b7e19c8e9a27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97c33f490d6aa28b505162dd9befb9efe1589dc706b53c60b267b7e19c8e9a27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97c33f490d6aa28b505162dd9befb9efe1589dc706b53c60b267b7e19c8e9a27"
    sha256 cellar: :any_skip_relocation, sonoma:        "50be6177ab396d0c3b7e606968c0265ac6beda7422c21940a29d6706c9b658fd"
    sha256 cellar: :any_skip_relocation, ventura:       "50be6177ab396d0c3b7e606968c0265ac6beda7422c21940a29d6706c9b658fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97c33f490d6aa28b505162dd9befb9efe1589dc706b53c60b267b7e19c8e9a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97c33f490d6aa28b505162dd9befb9efe1589dc706b53c60b267b7e19c8e9a27"
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
