class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.2.7.tgz"
  sha256 "28215624368a1f08a9fc6afc31246b799c0997b9ab68718a4e266196c6ca890d"
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
