class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.68.tgz"
  sha256 "f8a1769912ee1e50ee293040387b75679da0dfc0cacd5050e3c58e121c0121a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9415a5d11d7b81358893d3609a0710cb2e70103de1841ca5eed54aef0c40e218"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
