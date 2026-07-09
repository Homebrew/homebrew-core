class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.8.9.tgz"
  sha256 "bc9c40e525e6558a8081eabfddfbea0916cb1c9d2e805f66fe2d73d56ec555cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ff7e4ebba40b9affbdc93e2f76035440ee0a54d3f7e4c7cc77bc0621a837e56"
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
