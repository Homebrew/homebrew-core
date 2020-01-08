require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.20.2.tgz"
  sha256 "2d14384437fb498de7dad474a92c1840b5d4d9b8a9702a19fa1c640110d03d1a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5f88793dcba112448f2c6d0dcdfaecb650087d723e488b3c0d41e72af8a3535" => :catalina
    sha256 "54dd71344356b49404549ebcb468c7c072e586b5c6cd3f90300f094545a6c540" => :mojave
    sha256 "f52b2b0cd334a513e33ba70feb1a7e50ec36aa178ad350b199fab156d4960747" => :high_sierra
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
