require "language/node"

class Paqt < Formula
  desc "CLI for reliable folder archiving and cleaning with timestamp preservation"
  homepage "https://github.com/difhel/paqt"
  url "https://registry.npmjs.org/paqt/-/paqt-1.0.4.tgz"
  sha256 "803f0b52ce0ecd6e50dbb5249a0f96b7e61bf1a9515b53f166a66d8fa131d4c8"
  license "MIT"
  depends_on "node"
  depends_on "zpaq"

  def install
    # Install the prebuilt packagetarball into libexec and link the binary
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/paqt"]
  end

  test do
    # Verify that paqt runs and reports its version
    output = shell_output("#{bin}/paqt --version")
    assert_match version.to_s, output
  end
end
