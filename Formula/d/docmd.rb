class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.2.8.tgz"
  sha256 "77335be3131a90b9a38c81b46a37f6acaccbd325d298b0c4eb21cedc359813f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f39a0ddadee88ca8948628c6e0df93f6ac16cc74bd00a00e87ed93e63ab8fbff"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match "title: \"Welcome\"", (testpath/"docs/index.md").read
  end
end
