class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.22.3.tgz"
  sha256 "95bcbf01d8aa080babe8aedc8bf4ff3da5f4dc0204dcd9c6b4225f6a29070982"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e744df93df917bed6695fee461284d47926f28fbe630f37ae2c1ea500896f96b"
    sha256 cellar: :any, arm64_sequoia: "336e8ebaebcf4073112cd527cccc657b63be213f178427d85cc30cf40bff0f88"
    sha256 cellar: :any, arm64_sonoma:  "336e8ebaebcf4073112cd527cccc657b63be213f178427d85cc30cf40bff0f88"
    sha256 cellar: :any, sonoma:        "7dbf8ed32d5d809af4dc710436ebb8a3ebc55b5c78f6a2368a2627c4748d57f8"
    sha256 cellar: :any, arm64_linux:   "7f9a3eb217960d744791c083a8f376c9d3a79d3dc282061ecc1c5191e46581fc"
    sha256 cellar: :any, x86_64_linux:  "a3b0bdb1ab8c7f0e9d2130bf5206ff7e4e0cc1288b668b43b2b0acfd118a16bb"
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
