class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.9.2.tgz"
  sha256 "1db84b0cdd56406ad3baeeb6d25191ef8ba0eb018b8ba26c816f7445a3bf325f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "34b3ae4cf6e397e50c1cee1b6f8ce3ddebb99a96682187005edf108d7495cfbd"
    sha256 cellar: :any,                 arm64_sonoma:  "34b3ae4cf6e397e50c1cee1b6f8ce3ddebb99a96682187005edf108d7495cfbd"
    sha256 cellar: :any,                 arm64_ventura: "34b3ae4cf6e397e50c1cee1b6f8ce3ddebb99a96682187005edf108d7495cfbd"
    sha256 cellar: :any,                 sonoma:        "c1835404a94bb006524df1fd1b64201d3102bd10e8e316b7d33ad22a91ed2ea2"
    sha256 cellar: :any,                 ventura:       "c1835404a94bb006524df1fd1b64201d3102bd10e8e316b7d33ad22a91ed2ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "693d8e77e3c558c80471f7296d8366d3e2d338df3e145167fb9e58d1c70f3beb"
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
