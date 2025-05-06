class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.62.tgz"
  sha256 "192c746a3b57687c6819d85e5f77e0b2541a62d4d68325ff4934c6f7dda3cb17"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23602fc5eb3650c7c2a3ccd1f83e28680c13873b5dc7d14a5db12a59ebfdd898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23602fc5eb3650c7c2a3ccd1f83e28680c13873b5dc7d14a5db12a59ebfdd898"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23602fc5eb3650c7c2a3ccd1f83e28680c13873b5dc7d14a5db12a59ebfdd898"
    sha256 cellar: :any_skip_relocation, sonoma:        "07c5f677da05ca387cd8671617f3957c2ba2876a64267284912f515a19770123"
    sha256 cellar: :any_skip_relocation, ventura:       "07c5f677da05ca387cd8671617f3957c2ba2876a64267284912f515a19770123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23602fc5eb3650c7c2a3ccd1f83e28680c13873b5dc7d14a5db12a59ebfdd898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23602fc5eb3650c7c2a3ccd1f83e28680c13873b5dc7d14a5db12a59ebfdd898"
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
