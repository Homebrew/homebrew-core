class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.15.tgz"
  sha256 "c9bda60ce9eef8ba37f7d37f3e4cb478807352c1d6415f1274930ff30c2893ec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62c7f062019bf9a0e2672c1b3d71fdcfe9db095f377024ae459e9d3b014e0f3b"
    sha256 cellar: :any,                 arm64_sonoma:  "62c7f062019bf9a0e2672c1b3d71fdcfe9db095f377024ae459e9d3b014e0f3b"
    sha256 cellar: :any,                 arm64_ventura: "62c7f062019bf9a0e2672c1b3d71fdcfe9db095f377024ae459e9d3b014e0f3b"
    sha256 cellar: :any,                 sonoma:        "298a584ada7cd3be692562fbba4d3352842031638020386b2501534c2cc7095c"
    sha256 cellar: :any,                 ventura:       "298a584ada7cd3be692562fbba4d3352842031638020386b2501534c2cc7095c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e00a2cf16e1dcc4ba1d0c3c83130a2b85a2037ca6cd339f68e5482f9c89ee39"
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
