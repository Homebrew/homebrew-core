class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.26.0.tgz"
  sha256 "aea1df82f95b11012c616f9534931b4496cc2064f0ef42af84be2d62c73d9858"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58c237da31f7e611e79689ecc1379b11d9d6d8c357ec653e0812ead2d30752d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58c237da31f7e611e79689ecc1379b11d9d6d8c357ec653e0812ead2d30752d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58c237da31f7e611e79689ecc1379b11d9d6d8c357ec653e0812ead2d30752d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2712e34dfd8d803d115120bd0a5df98cf108073d3824006f40ccab5d551ad147"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1eed095fd16ca364f4eb14675ff20110417b1ef751b003db6f3950da203fe6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e8f28271138d11829214a7eaa275c20d10572d7dd8fd66f6c4d68f4f974398"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
