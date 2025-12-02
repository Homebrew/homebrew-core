class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.3.0.tgz"
  sha256 "4cdec18c164926472728b7a0ae056a700170b0a4b6ce49efd2131321577c6343"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b43b26cee55bef1cc4f122410d9e207ff6f0bafcbf7d17b1949b5ee17ea19fb7"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@mgks/docmd/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match "title: \"Welcome\"", (testpath/"docs/index.md").read
  end
end
