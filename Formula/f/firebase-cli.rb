class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.29.0.tgz"
  sha256 "e8cbd5e2f4fd329120e559c8288312abe1761571023a1a92aa621c3b7459b3de"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5271d83d38d4b95a95d694d37d866f0cd0e422a8dddd061215bdf7690586fd0b"
    sha256 cellar: :any, arm64_sequoia: "5271d83d38d4b95a95d694d37d866f0cd0e422a8dddd061215bdf7690586fd0b"
    sha256 cellar: :any, arm64_sonoma:  "5271d83d38d4b95a95d694d37d866f0cd0e422a8dddd061215bdf7690586fd0b"
    sha256 cellar: :any, arm64_linux:   "df842b510d732acdc34e948d0e00c39498e557ebc430aaf64f07975333438289"
    sha256 cellar: :any, x86_64_linux:  "b4caf4bd5dc60975d7df750095192d89fdcfc94c64b58d13523a28f27b65066c"
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
