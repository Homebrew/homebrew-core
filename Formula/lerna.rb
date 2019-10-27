require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.18.3.tgz"
  sha256 "58e62ee6462c9ab3e13d4d85f953835c5260bab11cfb87186c54b2dbab6f57e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a74e039975124d7b806c53bb2fdbb58ca4770662f222e726e30eb91bb06d625" => :catalina
    sha256 "a92f9e57e3014b6ab3ead30c9f4235c9407a5679bbaf37f91c4c9fb27c96ae40" => :mojave
    sha256 "8ebb13831cdb0ec022a18b8104810a0c07f7f74623888c7bd483577d5b49e78f" => :high_sierra
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
