class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.244.tgz"
  sha256 "5e1c8c73656753b9b6e2705e289311742a1994060e3b7fdd048977eb76940048"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfe80cbe61b1beaebd91933c889ebbce6ec774b8b7ffabc836cdb6967e9c7031"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfe80cbe61b1beaebd91933c889ebbce6ec774b8b7ffabc836cdb6967e9c7031"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfe80cbe61b1beaebd91933c889ebbce6ec774b8b7ffabc836cdb6967e9c7031"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fc153cf46a3526589ab1f4c4abcfad16e55f5a2e1027219555ff0828b129672"
    sha256 cellar: :any_skip_relocation, ventura:       "4fc153cf46a3526589ab1f4c4abcfad16e55f5a2e1027219555ff0828b129672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfe80cbe61b1beaebd91933c889ebbce6ec774b8b7ffabc836cdb6967e9c7031"
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
