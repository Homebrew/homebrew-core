require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.142.tgz"
  sha256 "5ff8ff495a75cbf0cd6f5791ada78558cf59063d2814100a9ae84b85ff7069a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "081facfe3140a9cddc7b155c2b10853bc8bd8801c4852cba509f899e128106ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "081facfe3140a9cddc7b155c2b10853bc8bd8801c4852cba509f899e128106ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "081facfe3140a9cddc7b155c2b10853bc8bd8801c4852cba509f899e128106ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a2511bc966e7d7b7540f489d51edcf09364b42f5331e61bd9e77c73a80f5d20"
    sha256 cellar: :any_skip_relocation, ventura:        "6a2511bc966e7d7b7540f489d51edcf09364b42f5331e61bd9e77c73a80f5d20"
    sha256 cellar: :any_skip_relocation, monterey:       "6a2511bc966e7d7b7540f489d51edcf09364b42f5331e61bd9e77c73a80f5d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b08e60821163591163bf65416833718bd6c9ff5017e75aa8b74f1eff63b74e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
