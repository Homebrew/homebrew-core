class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.13.tgz"
  sha256 "7813a1bdb0f548a340494d8f225b87d33e40a89a48f460554b910be73101f172"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1169982c8a5f164eb74021cbc4728cb6a1ba238d18decc84d4f4abe9aa3eba3"
    sha256 cellar: :any,                 arm64_sonoma:  "c1169982c8a5f164eb74021cbc4728cb6a1ba238d18decc84d4f4abe9aa3eba3"
    sha256 cellar: :any,                 arm64_ventura: "c1169982c8a5f164eb74021cbc4728cb6a1ba238d18decc84d4f4abe9aa3eba3"
    sha256 cellar: :any,                 sonoma:        "f61eb626157e80364f204df5962b5224471ed0ba650afe8402abf5325adbc6ac"
    sha256 cellar: :any,                 ventura:       "f61eb626157e80364f204df5962b5224471ed0ba650afe8402abf5325adbc6ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6787a24c779a782d3e0c934c0997b27ff398363862a80adb4f2851fbd754c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63e4c6d671e2f4a789af9aa69e6a047972cd5b83674ec3ef24d08094e73c5e17"
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
