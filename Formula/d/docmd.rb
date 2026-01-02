class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.3.5.tgz"
  sha256 "6454ab81894aafba3b5a6aecf4d0c52a5c7fffcc60093c945ad9ddb045d2da80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4df122a63b020e2e99f3cff666dd96b33c2ccfe65e315af089dbcf00b5971bd2"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match "title: \"Welcome\"", (testpath/"docs/index.md").read
  end
end
