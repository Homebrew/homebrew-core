class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-6.2.2.tgz"
  sha256 "3cc183287c8cef68b1927100c5d1ca2e8e26f813cd14decbae909aa17cbe93e3"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1279f56150cc986ab0c28410af314069965f2c6a15096c46f55ecf3098470164"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    inreplace libexec/"lib/node_modules/appwrite-cli/install.sh", "/usr/local", "@@HOMEBREW_PREFIX@@"
    inreplace libexec/"lib/node_modules/appwrite-cli/ldid/Makefile", "/usr/local", "@@HOMEBREW_PREFIX@@"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
