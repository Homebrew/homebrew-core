class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-6.2.3.tgz"
  sha256 "5ee405540c42103d2815df21b16c75a62bbe9175092186d397b7ad09098dca9d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66f05e2d4313f2e1336329e49e6b823dbcb33882e68ea688404c542c2930ea2e"
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
