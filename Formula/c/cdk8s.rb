class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.263.tgz"
  sha256 "26b772697e33231cec93a5dcb1a573b95394b5623fc214a71f2c56b34b60afa3"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "973f16068867eadfdef67418a7427ecad7ddee39e1e80e41501848c8cafa592c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "973f16068867eadfdef67418a7427ecad7ddee39e1e80e41501848c8cafa592c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "973f16068867eadfdef67418a7427ecad7ddee39e1e80e41501848c8cafa592c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6da9e73380a2946a4619a138c59d469e6abf6e2e0e5430f2526257e484ec95ca"
    sha256 cellar: :any_skip_relocation, ventura:       "6da9e73380a2946a4619a138c59d469e6abf6e2e0e5430f2526257e484ec95ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "973f16068867eadfdef67418a7427ecad7ddee39e1e80e41501848c8cafa592c"
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
