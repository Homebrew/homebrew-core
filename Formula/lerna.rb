require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.22.1.tgz"
  sha256 "77a036b03fafd7a6915ef32ad9e0f5cb1950ae8c86ee27fa886e2e1bad4004ac"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f2b51b458e4379c8f4bf192eb532e567fa2a209eff59fc78aa4a73a2c95c9a4" => :catalina
    sha256 "363088564849de9b6c79ac5cdbbb872ca43841b0d80af27c85c696cbd2dc75bb" => :mojave
    sha256 "833823b45ebd250a74b170f980861ae9cc6831040e5362309e637d13291a97af" => :high_sierra
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
