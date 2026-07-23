class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.8.17.tgz"
  sha256 "c10d08fa30625da17fac1d1ff217697a726566b99a1de300f4e8027ec2942d01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "503219678d13745af64f6e0cbe0260f4079a0b8a46e885db874b580b182f1944"
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
