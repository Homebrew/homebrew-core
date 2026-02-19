class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.7.0.tgz"
  sha256 "f36c8354b4ff428b66a92512f361da89170c26c59fb03d5ac4d656396a55b467"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e09b382e1e675408ea4830b958d8b5892846e209a9a172140a9f77b23b73a682"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
