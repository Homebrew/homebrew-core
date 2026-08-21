class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.28.1.tgz"
  sha256 "c4b6dec1e0a9effe4b7777ec4cd0e9dec516ebd744d37355ab8ed6a706530b64"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d257e0b94bb537dd3ded2e84345aa7632a7473907fa5a96fc632b2568f80fc28"
    sha256 cellar: :any, arm64_sequoia: "d257e0b94bb537dd3ded2e84345aa7632a7473907fa5a96fc632b2568f80fc28"
    sha256 cellar: :any, arm64_sonoma:  "d257e0b94bb537dd3ded2e84345aa7632a7473907fa5a96fc632b2568f80fc28"
    sha256 cellar: :any, sonoma:        "b6db1cf78389fd428e85c4333d17b39d7ebd3e4f42e750e734d5781bd7a3be6a"
    sha256 cellar: :any, arm64_linux:   "4812d4d289c71d814157ad399bca95039d14708b45544a39b5ad82ba31490ebb"
    sha256 cellar: :any, x86_64_linux:  "9e7aa5908a9aa26ca8e748d62c337455f1fcd27a905d433b44d846e125e7c2ff"
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
