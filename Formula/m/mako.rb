class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.10.tgz"
  sha256 "b8c872ae8a742db7a72747277622e898674c621fea970ac806ef8deac000816f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be2d57e9c56c6593adaa60aef3c08e70a51f8a434bdcd780573f8dbe2c90e393"
    sha256 cellar: :any,                 arm64_sonoma:  "be2d57e9c56c6593adaa60aef3c08e70a51f8a434bdcd780573f8dbe2c90e393"
    sha256 cellar: :any,                 arm64_ventura: "be2d57e9c56c6593adaa60aef3c08e70a51f8a434bdcd780573f8dbe2c90e393"
    sha256 cellar: :any,                 sonoma:        "38005cdffd5b3fb836308a9523dece09ae9a0e4a882de2f718988175bccecddd"
    sha256 cellar: :any,                 ventura:       "38005cdffd5b3fb836308a9523dece09ae9a0e4a882de2f718988175bccecddd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5b045c6ac5feb936df88b834f0af956e2dc04fb17da3b141d53ed6a963d2579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78464e4091fbc59f47a9b42c2c0b0a416219fb3e5cbe3029471f308567263667"
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
