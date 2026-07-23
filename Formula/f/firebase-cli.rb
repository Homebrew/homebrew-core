class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.24.0.tgz"
  sha256 "15e1919f735d8caa4ddaf2d2e8e8a46b7895903ab0469e1bc6bfe11c4b4e6d9a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ffff20414b73327973f9dbf97ada8dca1c790d551f2670607c65b9a12e1ec532"
    sha256 cellar: :any, arm64_sequoia: "ffff20414b73327973f9dbf97ada8dca1c790d551f2670607c65b9a12e1ec532"
    sha256 cellar: :any, arm64_sonoma:  "ffff20414b73327973f9dbf97ada8dca1c790d551f2670607c65b9a12e1ec532"
    sha256 cellar: :any, sonoma:        "99cbac968b92882a17d07b8c4fa10167e29c22834afb55cffc7934bbcb00fcaf"
    sha256 cellar: :any, arm64_linux:   "776aec63ea9deb807e21b25c42d7085873f460f239b16b63d75f1183636452fc"
    sha256 cellar: :any, x86_64_linux:  "a5a50593b04e95455dce7c5df0ad9d33925e8559ed25808061599b184a889aa9"
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
