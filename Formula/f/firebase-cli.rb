class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.14.0.tgz"
  sha256 "1fa857c493585545e146c66a2daca73781cfe090dac316c2f64f406810726508"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ace84e806f875d8c2250a1939a1736cbdb81d59362d3f28b126d98792ae3f00"
    sha256 cellar: :any,                 arm64_sequoia: "a4792351779cb4f5d3e06fe12f4c5531dc916ee86f9fd17299df2ee01434bb64"
    sha256 cellar: :any,                 arm64_sonoma:  "a4792351779cb4f5d3e06fe12f4c5531dc916ee86f9fd17299df2ee01434bb64"
    sha256 cellar: :any,                 sonoma:        "776771be2fafb2d8bf0a6bb0e6774a4131d64c3064656f76e165b3518a46b07f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd72d0ce82588d99d23894b0d6ed7966d181a0ab28ac3dc28ab16fa1029de837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7544d361608525afb0455274fc50696aa0b6a9a663c22d0ab64b0e7a837c01a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
