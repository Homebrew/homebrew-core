class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.10.0.tgz"
  sha256 "4a0fb7bd5549fc993b4a67d31663903a4e9985aeed04afe4d683b5fef586876c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "efbac75da5fbc3bd1b2736daa7506230187432dccad1d028b342655deec97ed4"
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
