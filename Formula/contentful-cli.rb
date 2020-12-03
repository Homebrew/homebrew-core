require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.65.tgz"
  sha256 "1d614d0f43ab4122a76565958233e70d561f67d0a816fd30f480f4b45b74b0f1"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f0ab5934d75c10fb07e04618ef950f627874622f029aa590e82685d4fad1d755" => :big_sur
    sha256 "ac80f40888a85d18377c4b2a4155705152956cac4e00522c3a0832d4363ee389" => :catalina
    sha256 "79358dc157df52823cd6655ccd23d417e9be0ea679d923bc387a2664517387bf" => :mojave
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
