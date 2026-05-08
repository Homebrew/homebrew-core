class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.17.0.tgz"
  sha256 "57902a1fd7ab238d8707c50d7a09d62becb5e5c502395751cef530d96fe8906f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e84637bd3025ff4bc04d2b0d2298c18c5e7fc76caf2281a1bd4769bb8ee63727"
    sha256 cellar: :any,                 arm64_sequoia: "f0d7b5309177bb266baaf244cd8779d5f89051349c08e0b5d29d9f23fed7ecd5"
    sha256 cellar: :any,                 arm64_sonoma:  "f0d7b5309177bb266baaf244cd8779d5f89051349c08e0b5d29d9f23fed7ecd5"
    sha256 cellar: :any,                 sonoma:        "b3329aea8a2f13d385b55d8fe63e3de16ebddd722e09b5050c066eda9bfa056e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ae59e454d3b5fd35c2382ab58048b159bd34aa3ee215bcb17af822fd05766d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d7fbe507f9555f74b1336602322bf84d7bd9762c59b91a91d3cdb6d79c267e"
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
