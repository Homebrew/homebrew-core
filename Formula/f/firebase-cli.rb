class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.15.0.tgz"
  sha256 "0c22408e16d3298b7e774821ed51bbaf357f2503714dcf32bfe85f515e683d55"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ab192b3440572fe23ac48a5649c17d5d4887d68694757d1e2c79a967df6103f"
    sha256 cellar: :any,                 arm64_sequoia: "614f85155677397e6148bff54969a9b024c6b93ab39418599994b7d1e1209383"
    sha256 cellar: :any,                 arm64_sonoma:  "614f85155677397e6148bff54969a9b024c6b93ab39418599994b7d1e1209383"
    sha256 cellar: :any,                 sonoma:        "6465bf5253ebc4334a72a6d0b7d3155523a5ff9254c76fd22a2eaf4eae9a65de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef7f0b99cccfd82f3f2200720668f229c69a771f59244cf35c40e781bfbfc806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0ceed8524427b65d1001aa3680f4b52fd2b1e5bf2f10ba906d4f9b3e98c18b2"
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
