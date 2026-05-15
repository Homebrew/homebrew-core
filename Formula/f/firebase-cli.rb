class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.18.0.tgz"
  sha256 "f8aff59e5763a3fedf074ec8bb6127ada701b04b86635f04470350c55d80c5fa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f18155954f388ff4e2219bf854a9221155cab7ea787bbf1b22d60e527418b38"
    sha256 cellar: :any,                 arm64_sequoia: "34e1c841cbf6bf005d24034f5f4c6c69d47aeea7e7dfb6c048bf25bad2122bd1"
    sha256 cellar: :any,                 arm64_sonoma:  "34e1c841cbf6bf005d24034f5f4c6c69d47aeea7e7dfb6c048bf25bad2122bd1"
    sha256 cellar: :any,                 sonoma:        "1bbc2e357ef0a0dc6b60a3aa4fbf4ed8bcabdddb34d84f26d00bd6034917f244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2699f4656b3b186158e86d0bc9fdaad5d7590b7c3c156952cb19a483cb52f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67fd23260bedaf567b642be8f8ac587e8386231f3e6da69d9225e447668c1257"
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
