class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.35.0.tgz"
  sha256 "d1547cbb9e991f017ca693ca566e9b6f74956ed8a3bde3fe53f2d020bc7390d3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "63d91b3f6a9348a014f587fb7d2cc9611bb5a9179234fe74fcf194949c97e613"
    sha256 cellar: :any, arm64_tahoe:       "63d91b3f6a9348a014f587fb7d2cc9611bb5a9179234fe74fcf194949c97e613"
    sha256 cellar: :any, arm64_sequoia:     "63d91b3f6a9348a014f587fb7d2cc9611bb5a9179234fe74fcf194949c97e613"
    sha256 cellar: :any, arm64_linux:       "79c88bb8f5533b0b39fa99c9184515cba068e6077186ac75a2074af2ca6eaa06"
    sha256 cellar: :any, x86_64_linux:      "dc696f711f62a2e6ffa69469e9ab79d82fedd43fe1a2bdb8ca628dd2cc0e1b4e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"

    # Remove incompatible pre-built `bare-*` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("bare-{buffer,fs,path,os,url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
