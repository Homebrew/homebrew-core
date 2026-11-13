class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.36.0.tgz"
  sha256 "5784ea62f0b1066a55317d51d6faf4f932fef58c226f7828f5390729c0e56e59"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "49fc96d88ffedecb01293b5c1331cdb7cd02cf4e42ad15994bf53d8128143b8a"
    sha256 cellar: :any, arm64_tahoe:       "49fc96d88ffedecb01293b5c1331cdb7cd02cf4e42ad15994bf53d8128143b8a"
    sha256 cellar: :any, arm64_sequoia:     "49fc96d88ffedecb01293b5c1331cdb7cd02cf4e42ad15994bf53d8128143b8a"
    sha256 cellar: :any, arm64_linux:       "e67eb353a2573269d3b2d527e7cf1b9738d46987edc45add64e5d8e72371082d"
    sha256 cellar: :any, x86_64_linux:      "13cb9ef50c470592e8af390f3cc20222c11e70e16bda28f8d65c70e2309877f6"
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
