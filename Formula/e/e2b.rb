class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.2.4.tgz"
  sha256 "caba18a664f495d0228e8d17a6f01846c3fce613a7a8f094839f1bab1895b85f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "473505019f5b4c56bf8bb60c0aab55fff2bbc4e3ce15cbe202ccc605d2785d8c"
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
