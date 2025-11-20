class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.2.6.tgz"
  sha256 "3db8d1c514d57131c9ec2fc75bb8cf004ae3a783d52bc618ab398a7b6cb883f7"
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
