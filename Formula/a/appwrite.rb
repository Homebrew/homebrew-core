class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-7.0.0.tgz"
  sha256 "9056ace48bf565a5d931dcaaaf9591953c5b4dd31fdb2ac42e8e7be0088e3981"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d375dce9b14753fb79e1c318c64e58c69240f89293c98dc792595a9f1a4ac140"
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
