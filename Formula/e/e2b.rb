class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.2.5.tgz"
  sha256 "6681b07a7b0dda441817d8de872515a0f7cd9c97e352672144dc3218c379ecf7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa137499709d47e775c984e2a1ccdc45117ea6b94b0cb1fba26fdb3bc934379a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
