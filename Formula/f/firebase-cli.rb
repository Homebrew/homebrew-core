class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.34.0.tgz"
  sha256 "9b62d1d317064360f5a521be91249f3df2b29441445f433b1f6ab6a58913323f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6bf452bd25daf327a23c80caae329cae26b57f1ba2b9abbe4a2d9e7be6274241"
    sha256 cellar: :any, arm64_tahoe:       "6bf452bd25daf327a23c80caae329cae26b57f1ba2b9abbe4a2d9e7be6274241"
    sha256 cellar: :any, arm64_sequoia:     "6bf452bd25daf327a23c80caae329cae26b57f1ba2b9abbe4a2d9e7be6274241"
    sha256 cellar: :any, arm64_linux:       "5c82c7913041723919647d562781db2e5b90df853ac837976de1a682caaee5d4"
    sha256 cellar: :any, x86_64_linux:      "3789a4ede56ff9a7f80aa85ce00bddec1b3bd1acd36605ac32ee9e7d89467007"
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
