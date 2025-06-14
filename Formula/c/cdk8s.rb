class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.99.tgz"
  sha256 "489c842dda50e5c98d35bba1c7cee447144fb6ba30dedd513c61b5b471ac4612"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c299cde8575ebb195176fd753e8bd3296b42b17f3a427b168d9f1b433a5222d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c299cde8575ebb195176fd753e8bd3296b42b17f3a427b168d9f1b433a5222d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c299cde8575ebb195176fd753e8bd3296b42b17f3a427b168d9f1b433a5222d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "32d5c15cc0f5ca258048f84ede12dcccd46daa4435a5a9f8f1b5dd483debb903"
    sha256 cellar: :any_skip_relocation, ventura:       "32d5c15cc0f5ca258048f84ede12dcccd46daa4435a5a9f8f1b5dd483debb903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c299cde8575ebb195176fd753e8bd3296b42b17f3a427b168d9f1b433a5222d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c299cde8575ebb195176fd753e8bd3296b42b17f3a427b168d9f1b433a5222d0"
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
