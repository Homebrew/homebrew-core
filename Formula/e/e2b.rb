class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.22.0.tgz"
  sha256 "dfdc2a94a59f0e7e705b8648ce0aba406b1dbd3bd133ea3d46f71f20f8f41008"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ee8bfd2cc100ccde3967b5945767245065982fee591f69cae13617ddaf7cfc8"
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
