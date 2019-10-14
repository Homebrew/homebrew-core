require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.17.0.tgz"
  sha256 "183e3e47217d81a9c539ba5878ec75c1d1d5b2c161225921b7cdd2a1de1297a2"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ad9626c1931434a416676b6466da723cb8b189935ccf35d2a956020edc5de9f9" => :catalina
    sha256 "ca65bd7d87f6aba73f68ab163241d46e62a166ded0af5992c132d9bc33a6b579" => :mojave
    sha256 "05d2594eb5f908d38f205d3b1d59d4116c21b82492b1d08abe7b0859a165c37f" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
