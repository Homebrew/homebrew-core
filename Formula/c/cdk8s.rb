class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.204.9.tgz"
  sha256 "bb319a1c96097c80618c54f0790d23877420e4a16e87dc7e706f023667e62ca9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50e1c0dfea8a9cad72fdfece7ae447ac6ad0dea7a6fbcc2f3493a55c68c1ae01"
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
