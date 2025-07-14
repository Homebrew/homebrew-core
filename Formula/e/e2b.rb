class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.5.2.tgz"
  sha256 "c44b9e86618e63b2dcd0aedd83155fd2d9e30cc20aa0119c3a8004d8e5a41652"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e674aa1c32b9a0e50f2a4551be28749b2acc241031a181f3920b8a183c9ff16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e674aa1c32b9a0e50f2a4551be28749b2acc241031a181f3920b8a183c9ff16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e674aa1c32b9a0e50f2a4551be28749b2acc241031a181f3920b8a183c9ff16"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aa57f2038e27e567530655b2ca58cb9d543e2427ea4fc23eaacb9a2d87d7a72"
    sha256 cellar: :any_skip_relocation, ventura:       "4aa57f2038e27e567530655b2ca58cb9d543e2427ea4fc23eaacb9a2d87d7a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e674aa1c32b9a0e50f2a4551be28749b2acc241031a181f3920b8a183c9ff16"
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
