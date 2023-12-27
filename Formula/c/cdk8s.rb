require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.21.tgz"
  sha256 "13d5980cb9ece0be9b1127cbffae44aa29e6dc8d5f9394b025c52a01dd599587"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a7ff4806df6838c71a0e5b7f90290dfe7aa48688ab3bd299fabb7bd86b03cda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a7ff4806df6838c71a0e5b7f90290dfe7aa48688ab3bd299fabb7bd86b03cda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a7ff4806df6838c71a0e5b7f90290dfe7aa48688ab3bd299fabb7bd86b03cda"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6abd340ae7f032417abf9ae31fb8124d2ead8eafb86be7c6192bf49115d0581"
    sha256 cellar: :any_skip_relocation, ventura:        "c6abd340ae7f032417abf9ae31fb8124d2ead8eafb86be7c6192bf49115d0581"
    sha256 cellar: :any_skip_relocation, monterey:       "c6abd340ae7f032417abf9ae31fb8124d2ead8eafb86be7c6192bf49115d0581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a7ff4806df6838c71a0e5b7f90290dfe7aa48688ab3bd299fabb7bd86b03cda"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
