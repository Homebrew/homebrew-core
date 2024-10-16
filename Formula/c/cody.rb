class Cody < Formula
  desc "Sourcegraph Cody CLI"
  homepage "https://sourcegraph.com"
  url "https://registry.npmjs.org/@sourcegraph/cody/-/cody-5.5.15.tgz"
  sha256 "2f25357f26e7710b71e4abead3ad9ee3fc5817fbbd6a78cd6726556982bc935a"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", "--prefix=#{libexec}", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "The provided access token is invalid",
                 shell_output("#{bin}/cody auth login --access-token fake-token-sg-a7f9b2c4e6d8 2>&1", 1)
  end
end
