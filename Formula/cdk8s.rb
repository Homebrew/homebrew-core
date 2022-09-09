require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.106.tgz"
  sha256 "3f0ad464852b72865eee5c8b944de358f7388ca734696a220a6ef2f8e50abdf7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8205acf66f6cbcb4ca9ad29e1f79ff5e4f584a2bc2fdd72917b1251f3410a86c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8205acf66f6cbcb4ca9ad29e1f79ff5e4f584a2bc2fdd72917b1251f3410a86c"
    sha256 cellar: :any_skip_relocation, monterey:       "6341fc8c0b5889eaf621b5495f7e657be2f6c5bfaef9d04a3346fe6f24f0ee3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6341fc8c0b5889eaf621b5495f7e657be2f6c5bfaef9d04a3346fe6f24f0ee3b"
    sha256 cellar: :any_skip_relocation, catalina:       "6341fc8c0b5889eaf621b5495f7e657be2f6c5bfaef9d04a3346fe6f24f0ee3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8205acf66f6cbcb4ca9ad29e1f79ff5e4f584a2bc2fdd72917b1251f3410a86c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
