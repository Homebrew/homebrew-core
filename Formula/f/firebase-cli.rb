class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.30.2.tgz"
  sha256 "0bf952d8c5847485ba885e8dc5133f76f7c9503c876bdf02425f8f2c28e128d3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d08bd17c227c0007174ecfae1ddca91806f6d90da9bbae1f4b348233e0172829"
    sha256 cellar: :any, arm64_tahoe:       "d08bd17c227c0007174ecfae1ddca91806f6d90da9bbae1f4b348233e0172829"
    sha256 cellar: :any, arm64_sequoia:     "d08bd17c227c0007174ecfae1ddca91806f6d90da9bbae1f4b348233e0172829"
    sha256 cellar: :any, arm64_linux:       "de732cbb9123b5f54795dd7f968281132b35a0dc1cfb7d5f3bb68be4de3fec79"
    sha256 cellar: :any, x86_64_linux:      "2dc302a8749588ae39a1508a43229167d17104b7f27f7f3cc51a45e7972258ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
