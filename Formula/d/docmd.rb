class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.10.1.tgz"
  sha256 "6e2b0381d69e4ecd69beac936ef5ed5d6e3bef5ccbea5aa2f54e2f1a7b7486c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e7b39e411ec618a65aef6216637a0e14a876bae2f6aa456b89a4c55842d71d2a"
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
    assert_match 'title: "Quick Start"', (testpath/"docs/index.md").read
  end
end
