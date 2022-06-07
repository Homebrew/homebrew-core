require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.14.5.tgz"
  sha256 "3991512e1ced090e7928cab7b4528f60f7af8e5324060cfe837a7d1554a2467b"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f0243dd54d9dcd83aa997d362a7b67522305f2e8f7f796ec8ff70ac3501ef1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f0243dd54d9dcd83aa997d362a7b67522305f2e8f7f796ec8ff70ac3501ef1c"
    sha256 cellar: :any_skip_relocation, monterey:       "f1c0601f2239d1f18aa61bc87731fcd854368760c80df0c9dc62fc2e3951e89b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1c0601f2239d1f18aa61bc87731fcd854368760c80df0c9dc62fc2e3951e89b"
    sha256 cellar: :any_skip_relocation, catalina:       "f1c0601f2239d1f18aa61bc87731fcd854368760c80df0c9dc62fc2e3951e89b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f0243dd54d9dcd83aa997d362a7b67522305f2e8f7f796ec8ff70ac3501ef1c"
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
