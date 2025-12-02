class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.15.tgz"
  sha256 "dbb00cf6478daff39eb97de02c144a5b2552094b7c097dd2166a55968731cbab"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63d5c1b3555f8c3b4ca57b1582f0ae84a201ef17082fde72075118f319afa7a2"
    sha256 cellar: :any,                 arm64_sequoia: "2bc72acf40db0cb4c619d718afbead3f46ee5f13d6cac6913436597a51955392"
    sha256 cellar: :any,                 arm64_sonoma:  "2bc72acf40db0cb4c619d718afbead3f46ee5f13d6cac6913436597a51955392"
    sha256 cellar: :any,                 sonoma:        "d7b4e42daf4872f46d9fb6336e3abd8a12387573b1070b2ecf398a43bc93373b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4fda26cdd0ca34b72f8c0586a6eeffbebb88b39395b1a406b28423de6331627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1820c8d230657278544b24bd1b48d8363377a5a0fc3ca9b5d9252c273d7ad70"
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
