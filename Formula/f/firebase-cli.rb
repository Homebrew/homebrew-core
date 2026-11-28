class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.37.0.tgz"
  sha256 "3917a60aa6f1878945265892ca7ebefe0f54d1c9b03ce8af043acf3d80d16e1d"
  license "MIT"

  bottle do
    manifest_sha256 "95d2f81c869b32b1abdbe8396ed91a020d2a28d47a9eb79ba8191882e5a3e38e"
    sha256 cellar: :any, arm64_golden_gate: "22baae4e9abea98c54d7b6fc2bc4c3968b19a91d28f849a156153510db464aac"
    sha256 cellar: :any, arm64_tahoe:       "22baae4e9abea98c54d7b6fc2bc4c3968b19a91d28f849a156153510db464aac"
    sha256 cellar: :any, arm64_sequoia:     "22baae4e9abea98c54d7b6fc2bc4c3968b19a91d28f849a156153510db464aac"
    sha256 cellar: :any, arm64_linux:       "7f7e8f0895e9e0996b66f21d0e8bbc6162ccbd7b7b309a6d1c4087db952d5bb9"
    sha256 cellar: :any, x86_64_linux:      "51be5dab07c4d7f0a489570a9f295e598381d34e775bc59ecfc457485128f4ae"
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
