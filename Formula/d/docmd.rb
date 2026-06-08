class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.8.6.tgz"
  sha256 "e787edbbd2a9a04c6c13e6b1f7524a2cdff08102143fcca06939598dc338217e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa873add77bc1f3a6e8eb02573352a4830c0acc038cddea0008cd222786ab418"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.json"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end
