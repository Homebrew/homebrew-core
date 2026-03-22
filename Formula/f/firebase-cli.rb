class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.11.0.tgz"
  sha256 "d494c747c638f33f258640ea7aff5069652b2fc58537483b9980e0c79e86d1d8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e4e221008d96b31998096449d034586dea27fd26b979e2963b051f19d3364763"
    sha256 cellar: :any,                 arm64_sequoia: "10fb2f67b4fc59ef65854a2f69b27d583c809743e7e9010675fc7c9c1fc26bc4"
    sha256 cellar: :any,                 arm64_sonoma:  "10fb2f67b4fc59ef65854a2f69b27d583c809743e7e9010675fc7c9c1fc26bc4"
    sha256 cellar: :any,                 sonoma:        "f4f35331278a24edc5730821290f07c1276d9373d583f0739c7a5dbc3f75c26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc8e00e3885d0a5b62b9eb19caed43a6edba2b391b899b80eb736b4c89e187b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2addf2365bc17ba225a391f26f278427af017faf765a67115ffbb5e4b69b7419"
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
