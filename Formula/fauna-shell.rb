require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.13.0.tgz"
  sha256 "a6dc40319b61efd1a3e3804e670d02d85a2424c251cb9288bc9a422f0995d8c6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b448922ce290174421373c5cd61dc66c4a7402f0e91f04ebe546628c01a3c66e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b448922ce290174421373c5cd61dc66c4a7402f0e91f04ebe546628c01a3c66e"
    sha256 cellar: :any_skip_relocation, monterey:       "e262bbd89eefe223ed454cda7d6401c3f21e86fcd14e677d2b6853242b49952a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e262bbd89eefe223ed454cda7d6401c3f21e86fcd14e677d2b6853242b49952a"
    sha256 cellar: :any_skip_relocation, catalina:       "e262bbd89eefe223ed454cda7d6401c3f21e86fcd14e677d2b6853242b49952a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b448922ce290174421373c5cd61dc66c4a7402f0e91f04ebe546628c01a3c66e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_match "fauna_endpoint *\n", output
  end
end
