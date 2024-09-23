class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.226.tgz"
  sha256 "84b761fc6eb2a7e14ba4ab9f3c0d81cb82637590c2a79696e118fb6e3fca00a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "743102e98f02fef996df3cebe43a7d7ac06515976771f769630c84e9d096a1fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "743102e98f02fef996df3cebe43a7d7ac06515976771f769630c84e9d096a1fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "743102e98f02fef996df3cebe43a7d7ac06515976771f769630c84e9d096a1fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d0b01677d280921e2de4706c56d971bc31ee151c46d5297158ab381f588288"
    sha256 cellar: :any_skip_relocation, ventura:       "65d0b01677d280921e2de4706c56d971bc31ee151c46d5297158ab381f588288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "743102e98f02fef996df3cebe43a7d7ac06515976771f769630c84e9d096a1fe"
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
