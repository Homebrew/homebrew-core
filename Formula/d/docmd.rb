class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.10.2.tgz"
  sha256 "e9b2e1216b6d1805698595c92a40c828f3a54a4ce71dcbbda5aa8fa6e02b4eef"
  license "MIT"

  bottle do
    manifest_sha256 "94ee4c83959c6deee7ecbacc1d03ab4e0b2323910861bba46404d8155f38647e"
    sha256 cellar: :any_skip_relocation, all: "3f579f641a13d1489ae625b0dea90e5834603eb3d9c9a7f89f838a27278d8787"
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
