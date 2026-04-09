class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.13.0.tgz"
  sha256 "2e493d3bcbcaa0ad61bb174f3b6e74e3e12cc4a8ac3c519d58346f59b2783940"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "786a02a8655546d8f69757c1d54bebb72beedab168c6a98e1ffd830f87d9c11f"
    sha256 cellar: :any,                 arm64_sequoia: "782884081b1003227e7ae7b10eef6c240e66155e34c1f1d04798d9603106d41d"
    sha256 cellar: :any,                 arm64_sonoma:  "782884081b1003227e7ae7b10eef6c240e66155e34c1f1d04798d9603106d41d"
    sha256 cellar: :any,                 sonoma:        "198de8cd3c253c634eb1f70ae9a29ae5924dd9472eda528da2db48b22f4f28ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d87a14643da8093932189702c61aaabb1b09eebfef2c84f57024f6be311b114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b40e8c39521d3a4e64a7d483ba27c17ee007dd319d0b8c369604b243c94b57e7"
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
