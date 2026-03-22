class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.8.1.tgz"
  sha256 "1a0e9f71c15e29835f0aa82604faa56097b0907531d7c6bc98a54dbd70f1cfc3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "077cd3bc09d786c2b628fa729a6391d79480c99eec1d2e1120fe91a101226b80"
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
