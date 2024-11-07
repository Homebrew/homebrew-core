class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.9.5.tgz"
  sha256 "f9c81f29dffd19ea993131abb446de7040d397a49bdf90f0795babb9f4ab8dbc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8593df1272d7c2f690da44e4ab616f2221eb3b7490cf7da721aff26d702b80bd"
    sha256 cellar: :any,                 arm64_sonoma:  "8593df1272d7c2f690da44e4ab616f2221eb3b7490cf7da721aff26d702b80bd"
    sha256 cellar: :any,                 arm64_ventura: "8593df1272d7c2f690da44e4ab616f2221eb3b7490cf7da721aff26d702b80bd"
    sha256 cellar: :any,                 sonoma:        "f1cf4b45eef654956745aceb21dcc4b9ada6201f4094d79310c1b35ab9f90949"
    sha256 cellar: :any,                 ventura:       "f1cf4b45eef654956745aceb21dcc4b9ada6201f4094d79310c1b35ab9f90949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd8f7cdf39429beaf90c339243fc533324c109081fe5cff354e094d6e8d8cd3e"
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
