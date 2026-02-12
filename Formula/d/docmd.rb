class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.4.1.tgz"
  sha256 "e8e3faea544056b15d58174254bf86c5a0af4e9d1ee9a61303e709d9183467ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0a3bc4f0ff6efeedcb5cc2b3c641328a84cebacebb13c47b2678bfeef3865b4"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
