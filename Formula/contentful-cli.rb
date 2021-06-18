require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.8.0.tgz"
  sha256 "e02d0f73f6f0c0b6a194569f9070adc3819c220983d1aba593254cd56722fa6f"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a1ec49faa28e41377020a32102e412a0a14d9bf44b78bb4f8a11bf75a7d374a"
    sha256 cellar: :any_skip_relocation, big_sur:       "25692ccc2a5afc74f6c2fdf601a168cf2733d09785a81e2f26a23d768ea08dba"
    sha256 cellar: :any_skip_relocation, catalina:      "25692ccc2a5afc74f6c2fdf601a168cf2733d09785a81e2f26a23d768ea08dba"
    sha256 cellar: :any_skip_relocation, mojave:        "25692ccc2a5afc74f6c2fdf601a168cf2733d09785a81e2f26a23d768ea08dba"
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
