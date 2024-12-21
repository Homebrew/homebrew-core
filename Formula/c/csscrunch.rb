class Csscrunch < Formula
  desc "Simple CSS Parser to tokenize CSS, merge rules, and optimize it"
  homepage "https://github.com/gafreax/csscrunch"
  url "https://www.npmjs.com/package/@gafreax/csscrunch"
  version "1.0.17"
  sha256 "e43eb9b3aee1fe737b19a930c6035d1fe4989bfc2488eadb83be6d98e0528676"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    brew test
  end
end
