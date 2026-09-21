class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.20.0.tgz"
  sha256 "d68852c4f9a65af33e98c0d66f589a946a5adda82e5325f2a09b54d5fc6fccd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "570636a97773a2d47025974bb018f1b2eb0e2900e02740da92dd0fed44109bdb"
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
