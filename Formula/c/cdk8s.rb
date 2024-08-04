class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.179.tgz"
  sha256 "81be288a43df910fdeb674bce8091c886890344dd37fa7cff21dbe2ce09af127"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "731ab8801a26155c6ada37aa24b1fbd5f70bdf0fe9d53d24500e4410e3ec89e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "731ab8801a26155c6ada37aa24b1fbd5f70bdf0fe9d53d24500e4410e3ec89e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "731ab8801a26155c6ada37aa24b1fbd5f70bdf0fe9d53d24500e4410e3ec89e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "c536b797c56a36ecdd47f05c086248ce0e4d04314dfb707e8da863fec5de95ac"
    sha256 cellar: :any_skip_relocation, ventura:        "c536b797c56a36ecdd47f05c086248ce0e4d04314dfb707e8da863fec5de95ac"
    sha256 cellar: :any_skip_relocation, monterey:       "c536b797c56a36ecdd47f05c086248ce0e4d04314dfb707e8da863fec5de95ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "731ab8801a26155c6ada37aa24b1fbd5f70bdf0fe9d53d24500e4410e3ec89e1"
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
