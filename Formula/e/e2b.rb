class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.10.4.tgz"
  sha256 "52b132e36ff54139be2f4fd6db2d31810da0f7836e47e48905e7211099aea0c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c2e19892ef09fe1f4c1e18bac17a5c730f4e046655342e173e9919191120bcd"
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
