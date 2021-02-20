require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.5.25.tgz"
  sha256 "10f1676cee4a11dd19d2f80eab6f8280831763c832f1e7575f89a26e95b3f53f"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa5a111db7b3a7ee9998bff05c4358209efe23f7871b174db5c20ac2d82489ca"
    sha256 cellar: :any_skip_relocation, big_sur:       "be0c9f8858d12715568f80983da3a0e9e415c38811aa816ef008baffb6082e4e"
    sha256 cellar: :any_skip_relocation, catalina:      "891caaf3ada6d4b3bd1e87dd972f2d8e2d4bb8664af92f421a605e9ba93761a6"
    sha256 cellar: :any_skip_relocation, mojave:        "dce63227382d84f2cf964984acff736beae6fac3b742b4897ff72470c4a59dd8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
