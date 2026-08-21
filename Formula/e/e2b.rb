class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.16.3.tgz"
  sha256 "1d2ae6f11e479c7cb3de11267fab2d19aff3e6fd91c040d48161930b3b17af2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "809b82144a8264053aa9c32114873b430c7abbf119a4a11e62d4123ee621c9f9"
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
