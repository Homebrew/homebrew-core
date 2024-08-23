class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.4.tgz"
  sha256 "5b6a4c6ef6a9bfc2b546eaaa523dd6412a9e66eec149f9fafde7a2d2cd5001d3"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "84ee196197de41ed6a6561d346a6c4cb367a29a78b700c096e8c578149f191cf"
    sha256                               arm64_ventura:  "a292f42c37d63b00537f6e2997185d726edc548010b55241718448b0e1f7a849"
    sha256                               arm64_monterey: "9cf7a62f62ccb4825bef9a9151a6cf8d222f60f1764bd067ffe04d08be2c0643"
    sha256                               sonoma:         "82fa7b1c39e7360664dea1d4fffc7fd84121747e64adb5b49eb2ab5682249d09"
    sha256                               ventura:        "0a1184a727f4ea33dd12e385ffd78ae1a9caf5e80862223a4565fec42500b21d"
    sha256                               monterey:       "be93be0aa478dbf65a18e2a4c81d3d5124246bf1c45c9f480ced321c75265392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "debd86e0e1425966150ebf5378d14d29fe7803a8ddeaca5e3755b4ea77df400b"
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
