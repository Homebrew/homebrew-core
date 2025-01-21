class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.3.tgz"
  sha256 "6b231e9b1b8faf3a13e9f0e32207cd0a6a25767e265d7499b91a88a7199ec6d8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c91beb6fe9a75990514e203e57b9b83fb394830a768bddb5b54c9ea439a4d59"
    sha256 cellar: :any,                 arm64_sonoma:  "0c91beb6fe9a75990514e203e57b9b83fb394830a768bddb5b54c9ea439a4d59"
    sha256 cellar: :any,                 arm64_ventura: "0c91beb6fe9a75990514e203e57b9b83fb394830a768bddb5b54c9ea439a4d59"
    sha256 cellar: :any,                 sonoma:        "82ff5e74b8b46c237f7e3c60943e58ab455cfe018f8ce179199e0db5dcf11cfc"
    sha256 cellar: :any,                 ventura:       "82ff5e74b8b46c237f7e3c60943e58ab455cfe018f8ce179199e0db5dcf11cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1c4eaf5d84058cc55108d62dee03312cb699e2eeb3a286d27c1c0582d589a9"
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
