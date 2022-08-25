require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.15.0.tgz"
  sha256 "7c46d9985bfda403c41cb0d3be86c7d1218140b08261a64b7c32473ccb61205a"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1393db0d1dd3e162b0a6d8e5b0a56d2afef1f5c6b608b32252f1372f1c5dd5a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1393db0d1dd3e162b0a6d8e5b0a56d2afef1f5c6b608b32252f1372f1c5dd5a1"
    sha256 cellar: :any_skip_relocation, monterey:       "78858d24d9e62d734b8f7d0f4b399c37b0a8a0d4050f4cf9086c1c5759f54f4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "78858d24d9e62d734b8f7d0f4b399c37b0a8a0d4050f4cf9086c1c5759f54f4b"
    sha256 cellar: :any_skip_relocation, catalina:       "78858d24d9e62d734b8f7d0f4b399c37b0a8a0d4050f4cf9086c1c5759f54f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1393db0d1dd3e162b0a6d8e5b0a56d2afef1f5c6b608b32252f1372f1c5dd5a1"
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
