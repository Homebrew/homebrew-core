require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.23.0.tgz"
  sha256 "9001c6b4c9b89d4049548e172d97a6d160c469193b1394333bf4ede3f86dbc8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6474b7fa031d0b66276c8c132f7a2415308f59dfddb9896ec4e5adef5c570838"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6474b7fa031d0b66276c8c132f7a2415308f59dfddb9896ec4e5adef5c570838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6474b7fa031d0b66276c8c132f7a2415308f59dfddb9896ec4e5adef5c570838"
    sha256 cellar: :any_skip_relocation, ventura:        "849a6f487e02df68b1d2a8bfc673305837b38c52040b7f6fe4d6ce2bb4f18644"
    sha256 cellar: :any_skip_relocation, monterey:       "849a6f487e02df68b1d2a8bfc673305837b38c52040b7f6fe4d6ce2bb4f18644"
    sha256 cellar: :any_skip_relocation, big_sur:        "849a6f487e02df68b1d2a8bfc673305837b38c52040b7f6fe4d6ce2bb4f18644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6474b7fa031d0b66276c8c132f7a2415308f59dfddb9896ec4e5adef5c570838"
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
