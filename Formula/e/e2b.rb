class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.3.4.tgz"
  sha256 "ce969bfe26cb27a8c2bfdcc1391ab80d734a8706a339aa2a0f840080564472f6"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
