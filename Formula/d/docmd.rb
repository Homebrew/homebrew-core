class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.8.0.tgz"
  sha256 "76eb1591c2161379b1b199ee7885c3e1963004b0d9ec8c1d4b2dc19d7cd53c07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81b4fb1a8d436371f50dd22dcfdfe0f4903c9d02acebf249b6315b9103bb7ecd"
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
    assert_path_exists testpath/"docmd.config.js"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end
