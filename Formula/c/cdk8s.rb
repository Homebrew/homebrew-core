class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.256.tgz"
  sha256 "c8aaf6853ad951f1a38969b3fd1d9c9329244b6544b360d8076636ba07bb8047"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5f07a4225ce40764dcb4e12b421fc5893af13e896dbb83f357e7008b5f78e11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5f07a4225ce40764dcb4e12b421fc5893af13e896dbb83f357e7008b5f78e11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5f07a4225ce40764dcb4e12b421fc5893af13e896dbb83f357e7008b5f78e11"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ce996086c6217ffa3abd80b99df28fa824045a2ed4478b5a9a4a58ee60152dc"
    sha256 cellar: :any_skip_relocation, ventura:       "9ce996086c6217ffa3abd80b99df28fa824045a2ed4478b5a9a4a58ee60152dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f07a4225ce40764dcb4e12b421fc5893af13e896dbb83f357e7008b5f78e11"
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
