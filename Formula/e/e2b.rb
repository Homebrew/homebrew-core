class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.9.0.tgz"
  sha256 "74afdd3a0f93d263cd752564a3af202bc5086eed248facccd5b72b90317ecdcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4081bc592674d579eae9accd3a3cd3f28bb99a30128d2469ad444a5668e6e66"
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
