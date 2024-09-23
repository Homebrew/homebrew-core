class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.13.tgz"
  sha256 "3e2a477aeca74b019cc0e0cce6b32fd037dc1341c25d2ead6611d3c96c2c3224"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cba21f350435bc30fd1f74197aacee0c86017667122f475a7d112b7c28220274"
    sha256 cellar: :any,                 arm64_sonoma:  "cba21f350435bc30fd1f74197aacee0c86017667122f475a7d112b7c28220274"
    sha256 cellar: :any,                 arm64_ventura: "cba21f350435bc30fd1f74197aacee0c86017667122f475a7d112b7c28220274"
    sha256 cellar: :any,                 sonoma:        "94dd3b04d93861a5fa43af6cb05534de0935be39c633849488252e66640c7ae0"
    sha256 cellar: :any,                 ventura:       "94dd3b04d93861a5fa43af6cb05534de0935be39c633849488252e66640c7ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f647db3cfe43b1b9aa2a6f2eccba047add5cce46dc1df285f7628f528d894bd5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end
