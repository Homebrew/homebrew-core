class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.22.4.tgz"
  sha256 "381e555185aa6fc8bbcf8ec6fa28dc4619cbf465c9b6406b00ae2dbc795d64db"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ea4cbfba612746d26f7bb30c94a00802e3b1fe5615bbea229f3c825e8f404c42"
    sha256 cellar: :any, arm64_sequoia: "7b374bbdb034ba08d4fc57581472b9f55b00511044e3189618a075e21d12fe54"
    sha256 cellar: :any, arm64_sonoma:  "7b374bbdb034ba08d4fc57581472b9f55b00511044e3189618a075e21d12fe54"
    sha256 cellar: :any, sonoma:        "94caf289542e3ff4c401d299c01faafb1dfc5050d001deae5153e87f797286f5"
    sha256 cellar: :any, arm64_linux:   "72aabdf5801cd22f2c572de51f81a165562751c0c7105ac3c2aaa474afea84d3"
    sha256 cellar: :any, x86_64_linux:  "ce6f946484bea80445d7ca562c28d0bcc16c08b6ade98700023cb6a17bec990b"
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
