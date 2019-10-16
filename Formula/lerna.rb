require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.18.1.tgz"
  sha256 "7d3551670f9c849e8602fc81a24ceea7d15532c005de40c6d8cdcb08dbb1e231"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7e37e9aad453f6d485da60372034de6530b71d294f3533a6306041b2fa6ddf5" => :catalina
    sha256 "2b561a49e4bdd3b11e363211a0dc4cd60551c99d1032f5eaf59f80faeeb2312d" => :mojave
    sha256 "f36d87b1e2ab8beee02f879a596161aa4f330861a0e2cca229492ef300736350" => :high_sierra
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
